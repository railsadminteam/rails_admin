// Adding and removing the children of a nested-attributes association.
//
// The server renders one inert <template> per association, as the last child of
// the association's own .tab-content, carrying the association name and - for a
// collection - the placeholder index to substitute. Where a row goes follows
// from where that template sits, so nothing here is page-global.

let seq = 0;
const nextIndex = () => `${Date.now()}${seq++}`;

function emit(target, name, detail) {
  target.dispatchEvent(new CustomEvent(name, { detail, bubbles: true }));
}

function templateFor(button) {
  const name = button.dataset.nestedAdd;
  const selector = `template[data-nested-template="${name}"]`;
  const local = button
    .closest(".control-group")
    ?.querySelector(`:scope > .tab-content > ${selector}`);
  if (local) return local;
  // A custom partial may put the button outside the control group, which
  // link_to_add used to allow. Fall back to the enclosing row, then the form.
  const scope = button.closest(".fields") || button.closest("form");
  return scope?.querySelector(selector);
}

function add(button) {
  const template = templateFor(button);
  if (!template) return;
  const token = template.dataset.nestedIndex;
  // split/join rather than replaceAll: the bundle targets es2020.
  const html = token
    ? template.innerHTML.split(token).join(nextIndex())
    : template.innerHTML;
  template.insertAdjacentHTML("beforebegin", html);
  const field = template.previousElementSibling;
  emit(field, "rails_admin.nested_field_added", {
    field,
    association: template.dataset.nestedTemplate,
  });
}

function remove(button) {
  const field = button.closest(".fields");
  if (!field) return;
  const group = field.closest(".control-group");
  // A row the server rendered as new has nothing to destroy, so it just goes.
  const destroyed = field.dataset.nestedNew === undefined;
  if (destroyed) {
    const input = field.querySelector(':scope > input[name$="[_destroy]"]');
    if (input) input.value = true;
    // A hidden row must not keep the browser from submitting the form.
    field.querySelectorAll("[required]").forEach((el) => {
      el.required = false;
    });
  }
  // Fires while the row is still in the document, so a listener can walk up from it.
  emit(field, "rails_admin.nested_field_removed", { field, group, destroyed });
  if (destroyed) field.hidden = true;
  else field.remove();
}

// Delegated on the class, not on [data-nested-add]: stripping the
// add_nested_fields class is how a has_one enforces "one child only".
document.addEventListener("click", (event) => {
  const addButton = event.target.closest(".add_nested_fields");
  if (addButton) {
    event.preventDefault();
    add(addButton);
    return;
  }
  const removeButton = event.target.closest(".remove_nested_fields");
  if (removeButton) {
    event.preventDefault();
    remove(removeButton);
  }
});
