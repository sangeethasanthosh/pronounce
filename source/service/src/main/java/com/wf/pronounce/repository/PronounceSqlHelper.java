package com.wf.pronounce.repository;

import java.util.ArrayList;
import java.util.List;
import org.springframework.data.relational.core.sql.Column;
import org.springframework.data.relational.core.sql.Expression;
import org.springframework.data.relational.core.sql.Table;

public class PronounceSqlHelper {

    public static List<Expression> getColumns(Table table, String columnPrefix) {
        List<Expression> columns = new ArrayList<>();
        columns.add(Column.aliased("id", table, columnPrefix + "_id"));
        columns.add(Column.aliased("employee_id", table, columnPrefix + "_employee_id"));
        columns.add(Column.aliased("first_name", table, columnPrefix + "_first_name"));
        columns.add(Column.aliased("last_name", table, columnPrefix + "_last_name"));
        columns.add(Column.aliased("preferred_name", table, columnPrefix + "_preferred_name"));
        columns.add(Column.aliased("phonetics", table, columnPrefix + "_phonetics"));
        columns.add(Column.aliased("country", table, columnPrefix + "_country"));
        columns.add(Column.aliased("language", table, columnPrefix + "_language"));
        columns.add(Column.aliased("pronoun", table, columnPrefix + "_pronoun"));
        columns.add(Column.aliased("pronunciation", table, columnPrefix + "_pronunciation"));
        columns.add(Column.aliased("pronunciation_content_type", table, columnPrefix + "_pronunciation_content_type"));
        columns.add(Column.aliased("created_user", table, columnPrefix + "_created_user"));
        columns.add(Column.aliased("created_date", table, columnPrefix + "_created_date"));
        columns.add(Column.aliased("updated_user", table, columnPrefix + "_updated_user"));
        columns.add(Column.aliased("updated_date", table, columnPrefix + "_updated_date"));
        columns.add(Column.aliased("is_active", table, columnPrefix + "_is_active"));

        return columns;
    }
}
