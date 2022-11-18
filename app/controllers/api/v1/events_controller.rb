# frozen_string_literal: true

module Api
  module V1
    class EventsController < ApiController
      rescue_from ApiExceptions::BaseException,
      with: :render_error_response

      before_action :authenticate_user, only: %i[create edit update destroy]
      before_action :editor?, only: %i[create edit update destroy]

      def index
        render json: event_serializer(events), status: :ok
      end

      def create
        new_event = Event.new(event_params)

        if new_event.save
          current_user.add_role :creator, new_event
          render json: event_serializer(new_event), status: :created
        else
          render json: { error: 'Error creating event' }, status: :unprocessable_entity
        end
      end

      def show
        if event
          render json: event_serializer(event), status: :found
        else
          render json: { error: 'Event not found' }, status: :not_found
        end
      end

      def destroy
        if event.destroy
          render json: { message: 'event was successfully destroyed' }, status: :no_content
        else
          render json: { error: 'Error destroying event' }, status: :unprocessable_entity
        end
      end

      def update
        if event.update(event_params)
          render json: event_serializer(event), status: :ok
        else
          render json: { error: 'Error updating event' }, status: :unprocessable_entity
        end
      end

      private

      def events
        Event.all
      end

      def event
        Event.find(params[:id])
      end

      def editor?
        valid_roles = %w[admin editor]
        raise ApiExceptions::PermitError::InsufficientPermitsError unless current_user.roles.pluck(:name).select { |role| valid_roles.include?(role) }.any?
      end

      def event_params
        params.require(:event).permit(:name, :description, :location, :category_id, :start_date, :end_date, :cover, images: [])
      end
    end
  end
end
