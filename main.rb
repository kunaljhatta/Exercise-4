# Exercise 5 Part 1 (Exception Handling)
class ConnectionError < ArgumentError; end

class MentalState
  def auditable?
    # true if the external service is online, otherwise false
  end

  def audit!
    # Could fail if external service is offline
  end

  def do_work
    # Amazing stuff...
  end
end

def audit_sanity(bedtime_mental_state)
  raise ConnectionError.new("external service is offline") if !bedtime_mental_state.auditable?
  if bedtime_mental_state.audit!.ok?
    MorningMentalState.new(:ok)
  else 
    MorningMentalState.new(:not_ok)
  end
end

begin
  new_state = audit_sanity(bedtime_mental_state)
rescue ConnectionError => e
  puts e.message
end

# Exercise 5 Part 2 (Don't Return Null / Null Object Pattern)

class BedtimeMentalState < MentalState ; end

class MorningMentalState < MentalState ; end

class NullMorningMentalState < MentalState ; end

def audit_sanity(bedtime_mental_state)
  raise ConnectionError.new("external service is offline") if !bedtime_mental_state.auditable?
  if bedtime_mental_state.audit!.ok?
    MorningMentalState.new(:ok)
  else
    MorningMentalState.new(:not_ok)
  end
end

begin
  new_state = audit_sanity(bedtime_mental_state)
rescue => ConnectionError
  new_state.NullMorningMentalState.new(:not_ok)
end
new_state.do_work

# Exercise 5 Part 3 (Wrapping APIs)

require 'candy_service'

class NotReadyException < ArgumentError ; end

class PersonalCandyMachine < CandyMachine

  def prepare ; end

  def ready ; end

  def make! 
    raise NotReadyException.new("Sadness") if !self.ready?
  end
end

machine = PersonalCandyMachine.new()
machine.prepare

begin 
  machine.make!
rescue NotReadyException => e    
  puts e.message
end