Facter.add(:psql_user) do
  case :kernel
    when 'OpenBSD'
      return '_postgresql'
    else
      return 'postgres'
  end
end

Facter.add(:have_psql) do
  setcode do
    confine :kernel => %w{Linux OpenBSD SunOS}
    psql_user = Facter.value(:psql_user)
    if Facter::Util::Resolution.exec(Facter.value('ps')).match(/^#{psql_user}/)
        "true"
    else
        "false"
    end
  end
end

Facter.add(:pgusers_array) do
  confine :have_psql => "true"
  setcode do
    psql_user = Facter.value(:psql_user)
    print "ARRAY: the user: #{psql_user}"
    pgusers_array = Facter::Util::Resolution.exec("psql -qAtX -U #{psql_user} -d postgres -c 'SELECT usename from pg_shadow where passwd is not null order by 1'").split("\n")
    pgusers_array
  end
end

Facter.add(:pgusers_hash) do
  confine :have_psql => "true"
  setcode do
    pgusers_array = Facter.value(:pgusers_array)
    psql_user = Facter.value(:psql_user)
    print "HASH: the user: #{psql_user}"
    pgusers_hash = {}

    pgusers_array.each do |user|
      passwd = Facter::Util::Resolution.exec("psql -qAtX -U #{psql_user} -d postgres -c \"SELECT passwd from pg_shadow where usename='#{user}'\"")
      if passwd
        pgusers_hash[user] = {'password' => passwd, 'username' => user}
      end
    end

    pgusers_hash
  end
end
