
atom_ns = 'http://www.w3.org/2005/Atom'
sword_ns = 'http://purl.org/net/sword/'
handle = 'http://hdl.handle.net/' + ENV['HS_PREFIX'] + '/' + @object.id
date_uploaded = DateTime.parse @object.date_uploaded.to_s
date_modified = DateTime.parse @object.date_modified.to_s
abstract = @object.abstract.empty? ? '' : @object.abstract.first
user_agent = request.headers['User-Agent']
packaging = request.headers['X-Packaging']
col_id = params[:collection_id]
default_rights = 'http://rightsstatements.org/vocab/InC/1.0/'
rights = @object.rights_uri.empty? ? default_rights : @object.rights_uri

xml.instruct!
xml.entry(xmlns: atom_ns) do
  # record metadata
  xml.id handle
  @object.creator.each do |creator|
    xml.author do
      xml.name creator
    end
  end
  xml.content(rel: 'src', type: 'text/xml', href: collection_work_url(col_id, @object))
  xml.generator(uri: 'http://scholarworks.calstate.edu/ns/sword', version: '2.0')
  xml.link(href: collection_work_file_sets_url(col_id, @object), rel: 'edit')
  xml.link(href: handle, rel: 'alternate', type: 'text/html')
  xml.published date_uploaded.strftime('%F')
  xml.rights(rights, type: 'text')
  xml.summary(abstract, type: 'text')
  xml.title(@object.title.join(', '), type: 'text')
  xml.updated date_modified.strftime('%FT%RZ')

  # file links
  @object.file_set_ids.each do |file_set_id|
    xml.content(rel: 'src', href: collection_work_file_set_url(col_id, @object, file_set_id))
    xml.link(rel: 'edit', href: collection_work_file_set_url(col_id, @object, file_set_id))
  end

  # sword cruft
  xml.treatment t('sword.treatment')
  xml.verboseDescription
  xml.noOp('false', xmlns: sword_ns)
  xml.userAgent(user_agent, xmlns: sword_ns)
  xml.packaging(packaging, xmlns: sword_ns)
end
