module RoleMocking

  def double_roles(*roles)
    roles.each do |class_name|
      Object.send(:remove_const, class_name.to_sym) rescue nil
      Object.const_set(class_name, double(class_name))
      klass = Object.const_get(class_name)
      klass.stub(:name).and_return(class_name)
      klass.stub(:is_a?).with(Class).and_return(true)
    end
  end

  def stub_user_roles(user, *roles)
    class_names = roles.map { |role| role.to_s.classify }
    double_roles(*class_names)
    user.stub(:roles).and_return(class_names.map do |class_name|
      factory = create(:role)
      factory.stub(:class).and_return(Object.const_get(class_name))
      factory
    end)
  end
end
