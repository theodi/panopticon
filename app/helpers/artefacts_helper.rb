module ArtefactsHelper
  def published_url(artefact)
    Plek.current.website_root + "/#{artefact.slug}"
  end

  def human_timestamp(timestamp)
    timestamp ? timestamp.strftime("%d/%m/%Y %R") : "(no timestamp)"
  end

  def name_hint_for(artefact)
    artefact.persisted? ? "This should be edited in #{artefact.owning_app}" : "A name/title for the item"
  end

  def admin_url_for_edition(artefact, options = {})
    "#{Plek.current.find(artefact.owning_app)}/admin/publications/#{artefact.id}"
  end

  def manageable_formats
    Artefact::FORMATS_BY_DEFAULT_OWNING_APP['publisher']
  end

  def related_artefacts_json(related_artefacts)
    # not using to_json as it is adding extra attributes which are not needed
    # select2 needs a JSON object with id and text attributes
    related_artefacts.map {|a| { id: a.slug, text: a.name_with_owner_prefix } }.to_json
  end

  def action_information_phrase(action)
    return "Automatic snapshot" if !action.user && action.action_type == "snapshot"

    phrase = case action.action_type
    when 'create', 'update'
      "has #{action.action_type}d this artefact"
    else
      "did a #{action.action_type} action"
    end

    action_performed_by(action) << phrase
  end

  def action_performed_by(action)
    if action.task_performed_by
      "Automatic task: '#{action.task_performed_by}' "
    elsif action.user
      "#{action.user} <#{action.user.email}> "
    else
      "An unknown user or task "
    end
  end
end
