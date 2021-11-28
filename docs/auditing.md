# Auditing

You can display an historic of all actions done on any model/instance with the help of one of the provided plugin integration below:

- [PaperTrail](papertrail.md) (ActiveRecord)
- [mongoid_audit](https://github.com/rs-pro/mongoid-audit) (Mongoid)
- [Internal audit plugin](internal-audit-plugin.md) (ActiveRecord - legacy)

If you wish to rollback any changes recorded by PaperTrail, use [RailsAdminHistoryRollback](https://github.com/rikkipitt/rails_admin_history_rollback). It provides a visual diff of the model changes with the ability to revert. See below screenshots.

## Screenshots

![History view](https://github.com/rikkipitt/rails_admin_history_rollback/raw/master/screenshots/history.png "history view")

![Modal view](https://github.com/rikkipitt/rails_admin_history_rollback/raw/master/screenshots/modal.png "modal view")
