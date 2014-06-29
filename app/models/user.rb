class User < ActiveRecord::Base

  attr_accessor :auth

  def self.from_omniauth(auth)
    if user = User.find_by_email(auth.info.email)
      user.provider = auth.provider
      user.uid = auth.uid # Does this change? Save the user? Why reset it?
      user
    else
      where(auth.slice(:provider, :uid)).create do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        user.name = auth.info.name
        user.email = auth.info.email
        user.last_sign_in_at = Time.now
      end
    end
  end

  # Callback for sign-in
  def track
    self.last_sign_in_at = self.current_sign_in_at if self.current_sign_in_at
    self.current_sign_in_at = Time.now
    self.sign_in_count += 1
    self.save
  end

  # TODO: remove once root_folder db field
  # changed to root_folder_id
  def root_folder_id
    self.root_folder
  end

  # Cleanup to run if user signs out
  def sign_out
    Rails.cache.delete(keyring(:documents))
  end

  # Get projects, sections and files
  def setup_projects(api_client)
    options = {
      'q' => "'#{self.root_folder_id}' in parents",
      'fields' => 'items(alternateLink,id,kind,title)'
    }

    options = Proc.new{|folder_id| 
      {
        'q' => "'#{folder_id}' in parents",
        'fields' => 'items(alternateLink,id,kind,title)'
      }
    }

    projects = api_client.request('files.list', options.call(self.root_folder_id))

    projects_array = []
    # For each project, grab sections
    projects.items.each do |project|
      project_json = {
        id: project.id,
        title: project.title,
        url: project.alternate_link,
        sections: []
      }

      # For each section, grab files
      sections = api_client.request('files.list', options.call(project.id))
      sections.items.each do |section|
        section_json = {
          id: section.id,
          title: section.title,
          url: section.alternate_link,
          files: []
        }
        files = api_client.request('files.list', options.call(section.id))
        files.items.each do |file|
          file_json = {
            id: file.id,
            title: file.title,
            url: file.alternate_link
          }
          section_json[:files] << file_json
        end
        project_json[:sections] << section_json
      end
      projects_array << project_json
    end

    binding.pry

    Rails.cache.write(keyring(:projects), projects_array.to_json)

  end

  def keyring(key)
    case key.to_sym
    when :documents then "#{cache_prefix}documents"
    when :projects then "#{cache_prefix}projects"
    else
      nil
    end
  end

  protected

  def cache_prefix
    "#{self.uid}:"
  end

end
