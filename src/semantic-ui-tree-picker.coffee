$.fn.treePicker = (options) ->
  widget = $(@)
  picked = []
  nodes = []
  tabs = {}
  modal = $("""
    <div class="ui tree-picker modal">
      <i class="close icon"></i>
      <div class="header">
        #{options.name}

        <div class="ui menu">
          <a class="active tree item">
            <i class="list icon"></i> Выбрать
          </a>
          <a class="picked item">
            <i class="checkmark icon"></i> Выбранные <span class="count"></span>
          </a>
        </div>
      </div>
      <div class="ui search form">
        <div class="field">
          <div class="ui icon input">
            <input type="text" placeholder="Поиск">
            <i class="search icon"></i>
          </div>
        </div>
      </div>
      <div class="content">
        <div class="ui active inverted dimmer"><div class="ui text loader">Loading data</div></div>
        <div class="tree-tab">
          <div style="height: 400px"></div>
        </div>

        <div class="search-tab">
        </div>

        <div class="picked-tab">
        </div>
      </div>
      <div class="actions">
        <a class="ui blue button accept">Accept</a>
        <a class="ui button close">Close</a>
      </div>
    </div>
    """).modal(duration: 200)
  count = $('.count', modal)
  tabs =
    tree: $('.tree-tab', modal)
    search: $('.search-tab', modal)
    picked: $('.picked-tab', modal)

  initialize = () ->
    widget.html(options.name)
    widget.on('click', (e) ->
      modal.modal('show')
      loadNodes(options.data, {}, (nodes) ->
        $('.ui.active.dimmer', modal).removeClass('active')

        if widget.attr("data-picked-ids")
          options.picked = widget.attr("data-picked-ids").split(",")

        if options.picked
          for id in options.picked
            searchResult = recursiveNodeSearch(nodes, (node) -> "#{node.id}" == "#{id}")
            if searchResult.length
              picked.push(searchResult[0])

        tree = renderTree(nodes, height: '400px', overflowY: 'scroll')
        tabs.tree.html(tree)
        initializeTree(tree)
      )
    )

    $('.actions .accept', modal).on('click', (e) ->
      widget.html("#{options.name} (Выбрано #{picked.length} элементов)")
      modal.modal('close')

      if options.onSubmit
        options.onSubmit(picked)
    )

    $('.menu .tree', modal).on('click', (e) -> showTree())
    $('.menu .picked', modal).on('click', (e)-> showPicked())
    $('.search input', modal).on('keyup', (e) -> showSearch($(@).val()))

  loadNodes = (url, params={}, success) ->
    $.get(url, params, (response) ->
      nodes = $.parseJSON(response)
      success(nodes))

  showTree = ->
    $('.menu .item', modal).removeClass('active')
    $('.menu .tree', modal).addClass('active')
    tabs.tree.show()
    tabs.search.hide()
    tabs.picked.hide()

  showSearch = (query) ->
    if query isnt null and query != ""
      foundNodes = recursiveNodeSearch(nodes, (node) -> node.name.toLowerCase().indexOf(query.toLowerCase()) > -1)
      list = renderList(foundNodes, height: '400px', overflowY: 'scroll')

      $('.menu .item', modal).removeClass('active')
      tabs.search.show().html(list)
      tabs.tree.hide()
      tabs.picked.hide()
      initializeTree(list)

      $('.name', list).each(() ->
        name = $(@).text()
        regex = RegExp( '(' + query + ')', 'gi' )
        name = name.replace( regex, "<strong class='search-query'>$1</strong>" )
        $(@).html(name)
      )
    else
      showTree()

  showPicked = ->
    list = renderList(picked, height: '400px', overflowY: 'scroll')

    $('.menu .item', modal).removeClass('active')
    $('.menu .picked', modal).addClass('active')
    tabs.picked.show().html(list)
    tabs.tree.hide()
    tabs.search.hide()

    initializeTree(list)

  renderTree = (nodes, css={}) ->
    tree = $('<div class="ui tree-picker tree"></div>').css(css)
    for node in nodes
      nodeElement = $("""
        <div class="node" data-id="#{node.id}" data-name="#{node.name}">
          <div class="head">
            <i class="add circle icon"></i>
            <i class="minus circle icon"></i>
            <a class="name">#{node.name}</a>
            <i class="checkmark icon"></i>
          </div>
          <div class="content"></div>
        </div>
      """).appendTo(tree)

      if node.nodes
        $('.content', nodeElement).append(renderTree(node.nodes))
      else
        nodeElement.addClass("childless")
    tree

  renderList = (nodes, css={}) ->
    list = $('<div class="ui tree-picker list"></div>').css(css)
    for node in nodes
      nodeElement = $("""
        <div class="node" data-id="#{node.id}" data-name="#{node.name}">
          <div class="head">
            <a class="name">#{node.name}</a>
            <i class="checkmark icon"></i>
          </div>
          <div class="content"></div>
        </div>
      """).appendTo(list)
    list

  initializeTree = (tree) ->
    $('.node', tree).each(() ->
      node = $(@)
      head = $('>.head', node)
      content = $('>.content', node)

      $('>.name', head).on('click', (e) ->
        nodeClicked(node)
      )

      if nodeIsPicked(node)
        node.addClass('picked')

      unless node.hasClass('childless')
        $('>.icon', head).on('click', (e) ->
          node.toggleClass('opened')
          content.slideToggle()
        )

      updatePickedIds()
    )

  nodeClicked = (node) ->
    node.toggleClass('picked')
    if node.hasClass('picked')
      pickNode(node)
    else
      unpickNode(node)

  pickNode = (node) ->
    id = node.attr('data-id')
    picked.push(id: id, name: node.attr('data-name'))
    updatePickedIds()
    $(".node[data-id=#{id}]", modal).addClass('picked')

  unpickNode = (node) ->
    id = node.attr('data-id')
    picked = picked.filter((n) -> n.id isnt id)
    updatePickedIds()
    $(".node[data-id=#{id}]", modal).removeClass('picked')

  nodeIsPicked = (node) ->
    picked.filter((n) -> "#{n.id}" is node.attr('data-id')).length

  updatePickedIds = ->
    widget.attr('data-picked-ids', picked.map((n) -> n.id))
    if picked.length
      count.closest('.item').addClass('highlighted')
      count.html("(#{picked.length})")
    else
      count.closest('.item').removeClass('highlighted')
      count.html("")

  recursiveNodeSearch = (nodes, comparator) ->
    results = []

    for node in nodes
      if comparator(node)
        results.push(id: node.id, name: node.name)
      if node.nodes
        results = results.concat(recursiveNodeSearch(node.nodes, comparator))

    results

  initialize()
