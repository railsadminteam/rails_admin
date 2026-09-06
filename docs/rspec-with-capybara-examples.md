### Go somewhere

```ruby
visit rails_admin.dashboard_path
visit rails_admin.index_path(model_name: 'blog~post')
visit rails_admin.new_path(model_name: 'blog~post')
visit rails_admin.edit_path(model_name: 'blog~post', id: post.id)
```

### Assert you landed somewhere

```ruby
expect(current_path).to eq rails_admin.dashboard_path
expect(current_path).to eq rails_admin.index_path(model_name: 'blog~post')
expect(current_path).to eq rails_admin.new_path(model_name: 'blog~post')
expect(current_path).to eq rails_admin.edit_path(model_name: 'blog~post', id: post.id)
```

### Click links

```ruby
# From anywhere
page.find('.dashboard_root_link a').click # to a root action
page.find('[data-model=blog~post] a').click # to any model index
# From any collection action
page.find('.new_collection_link a').click # to another collection action
# From any member action
page.find('.edit_member_link a').click # to another member action
# From the dashboard
page.find('.blog_post_links .index_collection_link a').click # to any collection action
# From the index page of a model
page.find('.blog_post_row[1] .show_member_link a').click # to any row's member action
```

### Assert the content

```ruby
expect(page.find('#blog_post_title')).to have_content 'Blog Post Title'              # of an edit/new form input
expect(page.find('.blog_post_row[1] .title_field').to have_content 'Blog Post Title' # of an index table row cell
expect(page.find('.alert')).to have_content 'Post successfully created'              # of a flash message
```
