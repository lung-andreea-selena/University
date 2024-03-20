module a7.interpreterwithgui {
    requires javafx.base;
    requires javafx.controls;
    requires javafx.fxml;
    requires javafx.graphics;

    exports a7.interpreterwithgui.gui;
    opens a7.interpreterwithgui.gui to javafx.fxml;

    exports a7.interpreterwithgui.controller;
    opens a7.interpreterwithgui.controller to javafx.fxml;

    exports a7.interpreterwithgui.exception;
    opens a7.interpreterwithgui.exception to javafx.fxml;

    exports  a7.interpreterwithgui.model.expression;
    opens a7.interpreterwithgui.model.expression to javafx.fxml;

    exports a7.interpreterwithgui.model;
    opens a7.interpreterwithgui.model to javafx.fxml;

    exports a7.interpreterwithgui.model.stmts;
    opens a7.interpreterwithgui.model.stmts to javafx.fxml;

    exports a7.interpreterwithgui.model.type;
    opens a7.interpreterwithgui.model.type to javafx.fxml;

    exports a7.interpreterwithgui.model.adt;
    opens a7.interpreterwithgui.model.adt to javafx.fxml;

    exports a7.interpreterwithgui.model.value;
    opens a7.interpreterwithgui.model.value to javafx.fxml;

    exports a7.interpreterwithgui.repository;
    opens a7.interpreterwithgui.repository to javafx.fxml;
    exports a7.interpreterwithgui;
    opens a7.interpreterwithgui to javafx.fxml;
}
