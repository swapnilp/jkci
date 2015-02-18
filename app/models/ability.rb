class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    alias_action :create, :read, :update, :to => :create_update


    if user.admin?
      can :manage, :all

    elsif user.staff?
      can :create_update, :chapter 
      can :read, :event 
      can :read, :jkci_class 
      can :read, :subject 
      can :read, :exam 
      can :read, :result 
      can :read, :teacher 
      can :read, :album 
      can :create_update, :class_catlog 
      can :create_update, :exam_absent 
      can :read, :batch 
      can :create_update, :exam_catlog 
      can :read, :results_photo 
      can :read, :class_student 
      can :manage, :exam_result 
      #can :manage, :batch_result 
      can :read, :gallery 
      #can :manage, :sms_sent 
      can :create_update, :daily_teaching_point 
      can :read, :student 
      
    elsif user.clark?
      can :create_update, :chapter 
      can :read, :event 
      can :read, :jkci_class 
      can :read, :subject 
      can :create_update, :exam 
      can :read, :result 
      can :read, :teacher 
      can :read, :album 
      can :create_update, :class_catlog 
      can :create_update, :exam_absent 
      can :read, :batch 
      can :create_update, :exam_catlog 
      can :read, :results_photo 
      can :create_update, :class_student 
      can :manage, :exam_result 
      #can :manage, :batch_result 
      can :read, :gallery 
      #can :manage, :sms_sent 
      can :create_update, :daily_teaching_point 
      can :read, :student 
    else
      can :read, :all
    end
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
