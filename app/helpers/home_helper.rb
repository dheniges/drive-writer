module HomeHelper

  # Turns a nested hash of projects and files
  # into a series of panes
  def render_panes(nested_projects)
    panes = []

    pane = Proc.new{|name, id|
      {
        name: name,
        id: id,
        items: []
      }.with_indifferent_access
    }

    project_panes = []
    section_panes = []
    file_panes = []

    project_pane = pane.call('Projects', 'projects_list_pane')
    nested_projects.each do |project|
      project_pane[:items] << project.except(:sections)
      sections_pane = pane.call("#{project['title']} Sections", "#{project['id']}_sections")
      project['sections'].each do |section|
        sections_pane[:items] << section.except(:files)
        files_pane = pane.call("#{section['title']} Files", "#{section['id']}_files")
        section['files'].each do |file|
          files_pane['items'] << file
        end
        file_panes << files_pane
      end
      section_panes << sections_pane
    end
    project_panes << project_pane

    {
      projects: project_panes,
      sections: section_panes,
      files: file_panes
    }
  end

end
