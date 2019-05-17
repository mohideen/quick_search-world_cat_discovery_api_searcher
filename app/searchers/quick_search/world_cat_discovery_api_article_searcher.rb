# frozen_string_literal: true

module QuickSearch
  # QuickSearch seacher for WorldCat, restricted to articles
  class WorldCatDiscoveryApiArticleSearcher < WorldCatDiscoveryApiSearcher
    def query_params
      {
        q: sanitized_user_search_query,
        itemType: 'artchap',
        startIndex: @offset,
        itemsPerPage: items_per_page,
        sortBy: 'library_plus_relevance'
      }
    end

    def loaded_link
      QuickSearch::Engine::WORLD_CAT_DISCOVERY_API_ARTICLE_CONFIG['loaded_link'] +
        sanitized_user_search_query
    end

    # Returns the link to use for the given item. If the item has a DOI
    # a direct link to the item is returned, otherwise a link to the
    # item in the OCLC catalog is returned.
    def item_link(bib)
      doi_link = bib.same_as&.to_s

      if doi_link
        doi_base_url = QuickSearch::Engine::WORLD_CAT_DISCOVERY_API_ARTICLE_CONFIG['doi_link']
        return doi_base_url + doi_link
      end

      QuickSearch::Engine::WORLD_CAT_DISCOVERY_API_ARTICLE_CONFIG['url_link'] +
        bib.oclc_number.to_s
    end

    # Returns the DOI link for the given item, or nil if no DOI is present
    def doi_link(bib)
      bib.same_as&.to_s
    end

    def include_type?
      false
    end
  end
end
