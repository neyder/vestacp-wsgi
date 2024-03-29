<VirtualHost %ip%:%web_port%>

    ServerName %domain_idn%
    %alias_string%
    ServerAdmin %email%
    DocumentRoot %docroot%
    ScriptAlias /cgi-bin/ %home%/%user%/web/%domain%/cgi-bin/
    Alias /vstats/ %home%/%user%/web/%domain%/stats/
    Alias /error/ %home%/%user%/web/%domain%/document_errors/
    SuexecUserGroup %user% %group%
    CustomLog /var/log/%web_system%/domains/%domain%.bytes bytes
    CustomLog /var/log/%web_system%/domains/%domain%.log combined
    ErrorLog /var/log/%web_system%/domains/%domain%.error.log
    <Directory %home%/%user%/web/%domain%/stats>
        AllowOverride All
    </Directory>

    <IfModule mod_ruid2.c>
        RMode config
        RUidGid %user% %group%
        RGroups www-data
    </IfModule>
    <IfModule itk.c>
        AssignUserID %user% %group%
    </IfModule>
    <IfModule mod_wsgi.c>
        WSGIDaemonProcess app-%domain% user=%user% group=%user% processes=1 threads=5 display-name=%{GROUP} python-home=%home%/%user%/web/%domain%/private/venv/ python-path=%home%/%user%/web/%domain%/private/%domain% socket-user=%user%
        WSGIProcessGroup app-%domain%
        WSGIApplicationGroup %{GLOBAL}
        WSGIScriptAlias / %home%/%user%/web/%domain%/private/%domain%/PROJECTAPP/wsgi.py process-group=app-%domain% application-group=%{GLOBAL}
    </IfModule>

    Alias /robots.txt %home%/%user%/web/%domain%/private/%domain%/static/robots.txt
    Alias /favicon.ico %home%/%user%/web/%domain%/private/%domain%/static/favicon.ico

    Alias /media/ %home%/%user%/web/%domain%/private/%domain%/media/
    Alias /static/ %home%/%user%/web/%domain%/private/%domain%/static/

    <Directory %home%/%user%/web/%domain%/private/%domain%/static>
        Require all granted
    </Directory>

    <Directory %home%/%user%/web/%domain%/private/%domain%/media>
        Require all granted
    </Directory>

    <Directory %docroot%>
        AllowOverride FileInfo
        Options ExecCGI Indexes
        MultiviewsMatch Handlers
        Options +FollowSymLinks
        Order allow,deny
        Allow from all
    </Directory>

#    <Directory %home%/%user%/web/%domain%/private/%domain%/PROJECTAPP>
#        <Files wsgi.py>
#            Require all granted
#        </Files>
#    </Directory>

    IncludeOptional %home%/%user%/conf/web/%web_system%.%domain%.conf*

</VirtualHost>
