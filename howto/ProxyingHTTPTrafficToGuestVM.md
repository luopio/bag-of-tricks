Proxying HTTP traffic from host to guest VM
===========================================


Nginx configuration on Host (for two virtual machines)
------------------------------------------------------

server {
    server_name  alpha.mothership.foo.fi;
    location / {
        proxy_pass         http://localhost:8000;
        proxy_set_header   X-Real-IP $remote_addr;
        proxy_set_header Host $host; # needed to capture subdomain.alpha.mothership.foo.fi on guest
    }
}

server {
    server_name  beta.mothership.foo.fi;
    location / {
        proxy_pass         http://localhost:9000;
        proxy_set_header   X-Real-IP $remote_addr;
    }
}


Example from guest capturing valo.alpha.mothership.foo.fi
-----------------------------------------------------------

<VirtualHost *:80>
  ServerName valo.alpha.mothership.foo.fi
  DocumentRoot /srv/valo_olympiakomitea/valo.fi/public
  # RailsEnv production
  <Directory /srv/valo_olympiakomitea/valo.fi/public>
    AllowOverride all
    Options -MultiViews
  </Directory>
</VirtualHost>

Note that several apps can run on same port with servername being the crucial separator. This again requires the Host
header to be set in the request.
