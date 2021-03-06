require 'securerandom'

module Infrastructure
  class UUIDIdGenerator
    def next_id
      SecureRandom.uuid
    end
  end

  class SequentialNumericGenerator
    def next_id
      @id ||= 0
      @id += 1
      @id
    end
  end

  class Repository
    attr_accessor :id_generator

    def initialize
      @entities = {}
    end

    def add(entity)
      id = id_generator.next_id
      entity.id = id
      entities[id] = entity.dup
    end

    def update(entity)
      entities[entity.id] = entity
    end

    def all
      entities.values.map(&:dup)
    end

    def find(id)
      entities[id].dup
    end

    def id_generator
      @id_generator ||= SequentialNumericGenerator.new
    end

    private
      attr_reader :entities

  end
end
