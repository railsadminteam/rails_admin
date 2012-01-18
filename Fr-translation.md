fr:
  home:
    name: Home
  views:
    pagination:
      previous: "&laquo; Préc."
      next: "Suiv. &raquo;"
      truncate: "…"
  admin:
    misc:
      search: "Rechercher"
      filter: "Filtrer"
      refresh: "Rafraîchir"
      show_all: "Voir tout"
      add_filter: "Ajouter un filtre..."
      bulk_menu_title: "Objets sélectionnés..."
      remove: "Enlever"
      add_new: "Ajouter nouveau"
      chosen: "%{name} choisis"
      chose_all: "Prendre tout"
      clear_all: "Tout enlever"
      up: "Monter"
      down: "Descendre"
      navigation: "Navigation"
      log_out: "Log out"
      ago: ""
    flash:
      successful: "%{name} a été %{action} avec succès"
      error: "%{name} n'a pas pu être %{action}"
      noaction: "Aucune action !"
      model_not_found: "Le model '%{model}' n'a pas été trouvé"
      object_not_found: "%{model} avec id '%{id}' n'a pas été trouvé"
    table_headers:
      model_name: "Nom du modèle"
      last_used: "Utilisé"
      records: "Enregistrements"
      username: "Utilisateur"
      changes: "Changements"
      created_at: "Date/Heure"
      item: "Objet"
      message: "Message"
    actions:
      dashboard:
        title: "Administration"
        menu: "Administration"
        breadcrumb: "Administration"
      index:
        title: "Listing des %{model_label_plural}"
        menu: "Liste"
        breadcrumb: "%{model_label_plural}"
      show:
        title: "Détails pour %{model_label} '%{object_label}'"
        menu: "Voir"
        breadcrumb: "%{object_label}"
      show_in_app:
        menu: "Voir dans l'application"
      new:
        title: "Création d'un(e) %{model_label}"
        menu: "Nouveau"
        breadcrumb: "Nouveau"
        link: "Ajouter un(e) %{model_label}"
        done: "créé(e)"
      edit:
        title: "Édition %{model_label} '%{object_label}'"
        menu: "Édition"
        breadcrumb: "Édition"
        link: "Éditer '%{object_label}'"
        done: "modifié(e)"
      delete:
        title: "Suppression %{model_label} '%{object_label}'"
        menu: "Supprimer"
        breadcrumb: "Suppression"
        link: "Supprimer '%{object_label}'"
        done: "supprimé(e)"
      bulk_delete:
        title: "Suppression de %{model_label_plural}"
        menu: "Délétion multiple"
        breadcrumb: "Délétion multiple"
        bulk_link: "Supprimer les %{model_label_plural} sélectionné(e)s"
      export:
        title: "Export de %{model_label_plural}"
        menu: "Export"
        breadcrumb: "Export"
        link: "Export des %{model_label_plural} trouvé(e)s"
        bulk_link: "Exporter les %{model_label_plural} sélectionné(e)s"
        done: "exporté(e)s"
      history_index:
        title: "Historique des %{model_label_plural}"
        menu: "Historique"
        breadcrumb: "Historique"
      history_show:
        title: "Historique %{model_label} '%{object_label}'"
        menu: "Historique"
        breadcrumb: "Historique"
    form:
      cancel: "Annuler"
      basic_info: "Informations de base"
      required: "Obligatoire"
      optional: "Facultatif"
      one_char: "caractère"
      char_length_up_to: "longueur jusqu'à"
      char_length_of: "longueur de"
      save: "Enregistrer"
      save_and_add_another: "Enregistrer et créer un(e) autre"
      save_and_edit: "Enregistrer et re-modifier"
      all_of_the_following_related_items_will_be_deleted: " ? Les objets suivants peuvent être affectés (supprimés ou orphelins) : "
      are_you_sure_you_want_to_delete_the_object: "Êtes-vous sûr de vouloir supprimer cet(te) %{model_name}"
      confirmation: "Oui, je suis sûr(e)"
      delete_confirmation: "Confirmation de suppression"
      bulk_delete: "Les objets suivants seront supprimés, ce qui pourrait supprimer ou rendre orpheline les dépendances affichées :"
    export:      
      confirmation: "Exporter en %{name}"
      select: "Sélectionner les champs à exporter"
      fields_from: "Champs pour '%{name}'"
      fields_from_associated: "Champs pour l'association '%{name}'"
      display: "Afficher %{name} : %{type}"
      options_for: "Options pour %{name}"
      empty_value_for_associated_objects: "<vide>"
      click_to_reverse_selection: 'Cliquer pour inverser la sélection'
      csv:
        header_for_root_methods: "%{name}" # 'model' is available
        header_for_association_methods: "%{name} [%{association}]"
        encoding_to: "Encoder en..."
        encoding_to_help: "Choisir l'encodage de sortie. Laisser vide pour garder l'encodage d'entrée : (%{name})"
        skip_header: "Pas d'en-tête"
        skip_header_help: "Ne pas afficher d'en-tête (pas de champs de description)"
        default_col_sep: ";"
        col_sep: "Séparateur de colonnes"
        col_sep_help: "Laisser vide pour utiliser la valeur par défaut recommandée pour votre système ('%{value}')"
