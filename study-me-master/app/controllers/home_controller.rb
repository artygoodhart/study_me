# Controller for homepage
class HomeController < PublicController
  def index
    @study_count = Study.all.count
    @university_count = University.all.count

    p @study_count
    p @university_count

    if @study_count >= 5
      all_studies = Study.all
      current_studies = all_studies.select { |study|
        study.timeslots.order(to: :desc).first.to >= DateTime.now unless (!study.timeslots_finalised || !study.paid)
      }
      p current_studies
      @studies = current_studies.first(5)
    end
  end
end
