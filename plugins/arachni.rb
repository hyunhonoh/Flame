module Arachni
	class Xml

		def initialize(cli, debug)
      @plugin  = 'Arachni'
      @author  =  {
                    :name     => 'Tiago Ferreira',
                    :contact  => 'tiago at blazeinfosec.com'
                  } 
		  @debug	 = debug
			@cli	   = cli
			@report  = Reportfile.new(@cli, @debug).read_file

		end

		def generate_event()
			@debug.status "Parsing \e[36m#{@plugin}\e[0m report XML file"
			flame_issues = {}
			parse = REXML::Document.new(@report)

      begin
            report_date  = parse.elements['//start_datetime'].text
            flame_issues = parse.elements.collect("//issues/issue") do |issue|  
          	   {
             	  :name             =>  issue.elements['name'].text,
              	:affected_point   =>  issue.elements['vector/url'].text,
              	:description      =>  issue.elements['description'].text,
             		:reference        =>  issue.elements['references'].elements.collect {|e| "#{e.attributes['name']} - #{e.attributes['url']}" }.join("\n"),
             		:severity         =>  issue.elements['severity'].text,
             	 	:cwe              =>  issue.elements['cwe'].nil? ? '' : issue.elements['cwe'].text,
              	:fix_procedure  =>  issue.elements['remedy_guidance'].nil? ? '' : issue.elements['remedy_guidance'].text,
              	:remedy_code      =>  issue.elements['remedy_code'].nil? ? '' : issue.elements['remedy_code'].text,
              	:cwe_url          =>  issue.elements['cwe_url'].nil? ? '' : issue.elements['cwe_url'].text,
                :report_time      =>  report_date
          	   }
            end
     
      rescue Exception => e
        @debug.error "Somenting went wrong. Please verify if the report scanner it was generated by #{@plugin}.\n"
        exit
      end

      return flame_issues
    end


  end

	class Html
	end
end