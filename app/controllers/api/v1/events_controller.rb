# frozen_string_literal: true

module Api
  module V1
    class EventsController < ApiController
      rescue_from ApiExceptions::BaseException,
      with: :render_error_response

      VALID_ROLES = %w[admin editor].freeze

      before_action :authenticate_user, except: %i[index show]
      before_action :allowed_to_edit?, only: %i[edit update destroy activate cancel postpone finish]
      before_action :allowed_to_create?, only: %i[create]

      def index
        render json: events, each_serializer: EventSerializer, status: :ok
      end

      def show
        if event
          render json: event, serializer: EventSerializer, status: :found
        else
          render json: { error: 'Event not found' }, status: :not_found
        end
      end

      def create
        new_event = Event.new(event_params)

        if new_event.save
          current_user.add_role :creator, new_event
          render json: new_event, serializer: EventSerializer, status: :created
        else
          render json: { error: 'Error creating event' }, status: :unprocessable_entity
        end
      end

      def update
        if event.update(event_params)
          render json: event, serializer: EventSerializer, status: :ok
        else
          render json: { error: 'Error updating event' }, status: :unprocessable_entity
        end
      end

      def destroy
        if event.destroy
          render json: { message: 'event was successfully destroyed' }, status: :no_content
        else
          render json: { error: 'Error destroying event' }, status: :unprocessable_entity
        end
      end

      def activate
        if event.on_hold? || event.postponed?
          event.activate!
          render json: { message: 'Event activated' }, status: :ok
        else
          render json: { error: "The status of the event doesn't allow to be activate" }, status: :unprocessable_entity
        end
      end

      def cancel
        if event.on_hold? || event.postponed? || event.active?
          event.cancel!
          render json: { message: 'Event canceled' }, status: :ok
        else
          render json: { error: "The status of the event doesn't allow to be cancel" }, status: :unprocessable_entity
        end
      end

      def postpone
        if event.on_hold? || event.active?
          event.postpone!
          render json: { message: 'Event postponed' }, status: :ok
        else
          render json: { error: "The status of the event doesn't allow to be postpone" }, status: :unprocessable_entity
        end
      end

      def finish
        if event.active?
          event.finish!
          render json: { message: 'Event finished' }, status: :ok
        else
          render json: { error: "The status of the event doesn't allow to be finished" }, status: :unprocessable_entity
        end
      end

      private

      def events
        Event.all.includes(%i[category images_attachments cover_attachment]).page(params[:page]).per(10)
      end

      def event
        Event.find(params[:id] || params['event_id'])
      end

      def allowed_to_edit?
        return if current_user.has_role? :creator, event

        raise ApiExceptions::PermitError::InsufficientPermitsError unless valid_user_roles?
      end

      def allowed_to_create?
        raise ApiExceptions::PermitError::InsufficientPermitsError unless valid_user_roles?
      end

      def valid_user_roles?
        current_user.roles.pluck(:name).select { |role| VALID_ROLES.include?(role) }.any?
      end

      def event_params
        params.require(:event).permit(:name, :description, :location, :category_list, :start_date, :end_date, :cover, images: [])
      end
    end
  end
end
