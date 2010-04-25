module TVRuby::HistList
  class HistRec
      def initialize( nId, nStr, nPrev=nil, nNext=nil)
        @id = nId
        @str = String.new(nStr)
        @next = nNext
        @prev = nPrev
      end

      attr_accessor :id
      attr_accessor :str
      attr_accessor :next
      attr_accessor :prev
  end

  def self.advance(ptr)
    ptr.next
  end

  def self.backup(ptr)
    ptr.prev
  end

  def self.next(ptr)
    ptr.next
  end

  def self.prev(ptr)
    ptr.prev
  end

  # 
  #  Specifies the size of the history block used by the history list manager
  #  to store values entered into input lines. The size is fixed by
  #  initHistory() at program startup.
  # 
  #  The default size of the block is 1K, but may be changed before
  #  initHistory() is called. The value should not be changed after the call to
  #  initHistory().
  #  @see initHistory
  # 
  @historySize = 1024;  # initial size of history block
  @curId
  @curRec
  class << self
    attr_accessor :historySize
    attr_accessor :curId
    attr_accessor :curRec
  end

  # 
  # Points to a buffer called the history block used to store history strings.
  # The size of the block is defined by historySize. The pointer is 0 until set
  # by the THistory constructor, and its value should not be altered.
  # @see THistory
  # 
  @historyBlock = []
  class << self
    attr_accessor :historyBlock
  end

  def self.advanceStringPointer
    @curRec = self.next( @curRec )
    while !@curRec.nil? && @curRec.id != @curId 
      @curRec = self.next( @curRec )
    end
  end

  def self.deleteString
    n = self.next(@curRec)
    p = self.prev(@curRec)
    p.next = n
    n.prev = p
    @curRec = n
  end

  def self.insertString( id, str )
    rec = HistRec.new(id,str,@historyBlock[-1])
    @historyBlock[-1] && @historyBlock[-1].next = rec
    @historyBlock << rec
  end

  def self.startId( id )
    @curId = id
    @curRec = @historyBlock[0]
  end

  def self.historyCount( id )
    startId( id )
    count = 0
    advanceStringPointer()
    while !@curRec.nil?
      count += 1
      advanceStringPointer()
    end
    return count
  end

  def self.historyAdd(id, str)
    if !str
      return
    end
    startId( id )
    advanceStringPointer()
    while !@curRec.nil?
      if str == @curRec.str
        deleteString()
      end
      advanceStringPointer()
    end
    insertString( id, str )
  end

  def self.historyStr( id, index )
      startId( id )
      0.upto(index) do |i|
        advanceStringPointer()
      end
      if !@curRec.nil?
        return @curRec.str
      else
        return nil
      end
  end

  def self.clearHistory
    @historyBlock = []
  end

  #
  # Called by TApplication constructor to allocate a block of memory on the
  # heap for use by the history list manager. The size of the block is
  # determined by the historySize variable. After initHistory() is called, the
  # historyBlock variable points to the beginning of the block.
  # @see TApplication
  # 
  def self.initHistory
      self.clearHistory
  end

  def self.doneHistory
  end
end

