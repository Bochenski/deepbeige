require_relative 'Node'
class NeuralNet
  attr_accessor :forward_nodes
  
  def initialize
    @Network = {}
  end  
  

    
  def attach_forward_node node
    @forward_nodes << node
  end  
  
protected  
  #Nets can procreate with other nets and produce a new net
  def procreate (dad)
  end
  
  #Nets can make small changes (mutations) to themselves
  def mutate
  end
  
private
  def detach_random_forward_node
  end
end