# Diffology (Backend)

Microsoft Access databases are typically kept in a drive made available over LAN, originating a fair number of issues. Diffology was a Microsoft Access Add-in that put a database’s schema and data into a git repository allowing users to easily synchronize all changes over the web.

This repository contains code for the backend. The code for the Microsoft Access Add-in can be found at https://github.com/vmsp/diffology_addin

* RAILS_ENV
* APP_DATABASE_PASSWORD
* RAILS_MASTER_KEY
* REPO_DIR ????
* RAILS_MAX_THREADS
* RAILS_MIN_THREADS

Deploy:
1. Stop puma
2. Stop nginx
3. cap deploy
4. cap run migrations
5. Start nginx
6. Start puma
