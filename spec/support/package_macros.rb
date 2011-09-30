module PackageMacros
  def to_table(packages,as_worker=false)
    packages.collect do |package|
      [
        as_worker ? package.recipient.name : nil,
        package.worker.name,
        package.received_at,
        package.delivered_by,
        package.comment
      ].compact
    end
  end
end
