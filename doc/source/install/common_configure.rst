2. Edit the ``/etc/heat_tempest_plugin/heat_tempest_plugin.conf`` file and complete the following
   actions:

   * In the ``[database]`` section, configure database access:

     .. code-block:: ini

        [database]
        ...
        connection = mysql+pymysql://heat_tempest_plugin:HEAT_TEMPEST_PLUGIN_DBPASS@controller/heat_tempest_plugin
