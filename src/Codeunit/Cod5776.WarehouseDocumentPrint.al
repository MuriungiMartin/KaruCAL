#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5776 "Warehouse Document-Print"
{

    trigger OnRun()
    begin
    end;


    procedure PrintPickHeader(WhseActivHeader: Record "Warehouse Activity Header")
    var
        WhsePick: Report "Picking List";
    begin
        WhseActivHeader.SetRange("No.",WhseActivHeader."No.");
        WhsePick.SetTableview(WhseActivHeader);
        WhsePick.SetBreakbulkFilter(WhseActivHeader."Breakbulk Filter");
        WhsePick.RunModal;
    end;


    procedure PrintPutAwayHeader(WhseActivHeader: Record "Warehouse Activity Header")
    var
        WhsePutAway: Report "Put-away List";
    begin
        WhseActivHeader.SetRange("No.",WhseActivHeader."No.");
        WhsePutAway.SetTableview(WhseActivHeader);
        WhsePutAway.SetBreakbulkFilter(WhseActivHeader."Breakbulk Filter");
        WhsePutAway.RunModal;
    end;


    procedure PrintMovementHeader(WhseActivHeader: Record "Warehouse Activity Header")
    var
        MovementList: Report "Movement List";
    begin
        WhseActivHeader.SetRange("No.",WhseActivHeader."No.");
        MovementList.SetTableview(WhseActivHeader);
        MovementList.SetBreakbulkFilter(WhseActivHeader."Breakbulk Filter");
        MovementList.RunModal;
    end;


    procedure PrintInvtPickHeader(WhseActivHeader: Record "Warehouse Activity Header";HideDialog: Boolean)
    var
        WhsePick: Report "Picking List";
    begin
        WhseActivHeader.SetRange("No.",WhseActivHeader."No.");
        WhsePick.SetTableview(WhseActivHeader);
        WhsePick.SetInventory(true);
        WhsePick.SetBreakbulkFilter(false);
        WhsePick.UseRequestPage(not HideDialog);
        WhsePick.RunModal;
    end;


    procedure PrintInvtPutAwayHeader(WhseActivHeader: Record "Warehouse Activity Header";HideDialog: Boolean)
    var
        WhsePutAway: Report "Put-away List";
    begin
        WhseActivHeader.SetRange("No.",WhseActivHeader."No.");
        WhsePutAway.SetTableview(WhseActivHeader);
        WhsePutAway.SetInventory(true);
        WhsePutAway.SetBreakbulkFilter(false);
        WhsePutAway.UseRequestPage(not HideDialog);
        WhsePutAway.RunModal;
    end;


    procedure PrintInvtMovementHeader(WhseActivHeader: Record "Warehouse Activity Header";HideDialog: Boolean)
    var
        MovementList: Report "Movement List";
    begin
        WhseActivHeader.SetRange("No.",WhseActivHeader."No.");
        MovementList.SetTableview(WhseActivHeader);
        MovementList.SetInventory(true);
        MovementList.SetBreakbulkFilter(false);
        MovementList.UseRequestPage(not HideDialog);
        MovementList.RunModal;
    end;


    procedure PrintRcptHeader(RcptHeader: Record "Warehouse Receipt Header")
    begin
        RcptHeader.SetRange("No.",RcptHeader."No.");
        Report.Run(Report::"Whse. - Receipt",true,false,RcptHeader);
    end;


    procedure PrintPostedRcptHeader(PostedRcptHeader: Record "Posted Whse. Receipt Header")
    begin
        PostedRcptHeader.SetRange("No.",PostedRcptHeader."No.");
        Report.Run(Report::"Whse. - Posted Receipt",true,false,PostedRcptHeader);
    end;


    procedure PrintShptHeader(ShptHeader: Record "Warehouse Shipment Header")
    begin
        ShptHeader.SetRange("No.",ShptHeader."No.");
        Report.Run(Report::"Whse. - Shipment",true,false,ShptHeader);
    end;


    procedure PrintPostedShptHeader(PostedShptHeader: Record "Posted Whse. Shipment Header")
    begin
        PostedShptHeader.SetRange("No.",PostedShptHeader."No.");
        Report.Run(Report::"Whse. - Posted Shipment",true,false,PostedShptHeader);
    end;
}

