col table_name format a40
select t.table_name,
       t.estimate_size,
       e.extent_size,
       t.used_blocks,
       e.extent_blocks,
       o.created,
       o.last_ddl_time
  from ( select table_name, num_rows * avg_row_len as estimate_size, blocks as used_blocks from user_tables) t
       inner join
       ( select segment_name, sum(BYTES) as extent_size, sum(blocks) as extent_blocks from user_extents group by segment_name ) e
    on t.table_name = e.segment_name
       inner join
       user_objects o
    on o.object_name = t.table_name
 order by o.created
;
col table_name clear