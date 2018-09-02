find_package(Protobuf-c REQUIRED)

# work around Protobuf exporting 'lpthread' as a library: we
# export the dependency on pthread using the CFG_EXTRAS files
#list (REMOVE_ITEM PROTOBUF_LIBRARIES "-lpthread")

# Add a protobuf helper function
function (compile_protobuf_module name)
    add_custom_command (
        COMMAND           ${PROTOBUFC_PROTOC_EXECUTABLE}
				ARGS							--c_out=${CMAKE_CURRENT_BINARY_DIR} ${name}.proto
        DEPENDS           "${name}.proto"
        OUTPUT            "${name}.pb-c.c" "${name}.pb-c.h"
        VERBATIM
        WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
    )
endfunction ()

if(BUILD_MAPTOOL)

	add_definitions( -DMODULE=maptool ${NAVIT_COMPILE_FLAGS})
	include_directories(${CMAKE_CURRENT_BINARY_DIR})
	include_directories(${PROTOBUF-C_INCLUDE_DIR})

	add_executable (maptool maptool.c)
	add_library (maptool_core boundaries.c buffer.c ch.c coastline.c itembin.c
		itembin_buffer.c misc.c osm.c osm_o5m.c osm_psql.c osm_relations.c
	 	sourcesink.c tempfile.c tile.c zip.c osm_xml.c)

	if(NOT MSVC)
		compile_protobuf_module ("osmformat")
		compile_protobuf_module ("fileformat")
		target_sources(maptool_core PRIVATE osm_protobuf.c osm_protobufdb.c
			fileformat.pb-c.c osmformat.pb-c.c)
		target_link_libraries(maptool_core ${PROTOBUF-C_LIBRARIES})
	endif(NOT MSVC)

	if(NOT MSVC)
		SET(NAVIT_LIBS ${NAVIT_LIBS} m)
	endif(NOT MSVC)

	target_link_libraries(maptool maptool_core ${NAVIT_LIBNAME} ${NAVIT_LIBS})

	install(TARGETS maptool
		DESTINATION ${BIN_DIR}
		PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)

endif()
