#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7315 "Warehouse Movement"
{
    Caption = 'Warehouse Movement';
    InsertAllowed = false;
    PageType = Document;
    RefreshOnActivate = true;
    SaveValues = true;
    SourceTable = "Warehouse Activity Header";
    SourceTableView = where(Type=filter(Movement));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'No.';
                    Editable = false;
                    ToolTip = 'Specifies the number of the warehouse header.';

                    trigger OnAssistEdit()
                    begin
                        if AssistEdit(xRec) then
                          CurrPage.Update;
                    end;
                }
                field(CurrentLocationCode;CurrentLocationCode)
                {
                    ApplicationArea = Basic;
                    Caption = 'Location Code';
                    Editable = false;
                    Lookup = false;
                }
                field("Breakbulk Filter";"Breakbulk Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that the intermediate Take and Place lines will not show as put-away, pick, or movement lines, when the quantity in the larger unit of measure is being put-away, picked or moved completely.';

                    trigger OnValidate()
                    begin
                        BreakbulkFilterOnAfterValidate;
                    end;
                }
                field("Assigned User ID";"Assigned User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ID of the user who is responsible for the document.';
                }
                field("Assignment Date";"Assignment Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the date when the user was assigned the activity.';
                }
                field("Assignment Time";"Assignment Time")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the time when the user was assigned the activity.';
                }
                field("Sorting Method";"Sorting Method")
                {
                    ApplicationArea = Basic;
                    OptionCaption = ' ,Item,,Bin Code,Due Date,,Bin Ranking,Action Type';
                    ToolTip = 'Specifies the method by which the lines are sorted on the warehouse header, such as Item or Document.';

                    trigger OnValidate()
                    begin
                        SortingMethodOnAfterValidate;
                    end;
                }
            }
            part(WhseMovLines;"Warehouse Movement Subform")
            {
                SubPageLink = "Activity Type"=field(Type),
                              "No."=field("No.");
                SubPageView = sorting("Activity Type","No.","Sorting Sequence No.")
                              where(Breakbulk=const(false));
            }
        }
        area(factboxes)
        {
            part(Control1901796907;"Item Warehouse FactBox")
            {
                Provider = WhseMovLines;
                SubPageLink = "No."=field("Item No.");
                Visible = true;
            }
            part(Control5;"Lot Numbers by Bin FactBox")
            {
                Provider = WhseMovLines;
                SubPageLink = "Item No."=field("Item No."),
                              "Variant Code"=field("Variant Code"),
                              "Location Code"=field("Location Code");
                Visible = false;
            }
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Movement")
            {
                Caption = '&Movement';
                Image = CreateMovement;
                action(List)
                {
                    ApplicationArea = Basic;
                    Caption = 'List';
                    Image = OpportunitiesList;
                    ShortCutKey = 'Shift+Ctrl+L';

                    trigger OnAction()
                    begin
                        LookupActivityHeader(CurrentLocationCode,Rec);
                    end;
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Warehouse Comment Sheet";
                    RunPageLink = "Table Name"=const("Whse. Activity Header"),
                                  Type=field(Type),
                                  "No."=field("No.");
                }
                action("Registered Movements")
                {
                    ApplicationArea = Basic;
                    Caption = 'Registered Movements';
                    Image = RegisteredDocs;
                    RunObject = Page "Registered Whse. Activity List";
                    RunPageLink = Type=field(Type),
                                  "Whse. Activity No."=field("No.");
                    RunPageView = sorting("Whse. Activity No.");
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("&Autofill Qty. to Handle")
                {
                    ApplicationArea = Basic;
                    Caption = '&Autofill Qty. to Handle';
                    Image = AutofillQtyToHandle;

                    trigger OnAction()
                    begin
                        AutofillQtyToHandle;
                    end;
                }
                action("&Delete Qty. to Handle")
                {
                    ApplicationArea = Basic;
                    Caption = '&Delete Qty. to Handle';
                    Image = DeleteQtyToHandle;

                    trigger OnAction()
                    begin
                        DeleteQtyToHandle;
                    end;
                }
                separator(Action4)
                {
                }
            }
            group("&Registering")
            {
                Caption = '&Registering';
                Image = PostOrder;
                action("&Register Movement")
                {
                    ApplicationArea = Basic;
                    Caption = '&Register Movement';
                    Image = RegisterPutAway;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        RegisterActivityYesNo;
                    end;
                }
            }
            action("&Print")
            {
                ApplicationArea = Basic;
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    WhseActPrint.PrintMovementHeader(Rec);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        CurrentLocationCode := "Location Code";
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.Update;
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        exit(FindFirstAllowedRec(Which));
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    begin
        exit(FindNextAllowedRec(Steps));
    end;

    trigger OnOpenPage()
    begin
        ErrorIfUserIsNotWhseEmployee;
    end;

    var
        WhseActPrint: Codeunit "Warehouse Document-Print";
        CurrentLocationCode: Code[10];

    local procedure AutofillQtyToHandle()
    begin
        CurrPage.WhseMovLines.Page.AutofillQtyToHandle;
    end;

    local procedure DeleteQtyToHandle()
    begin
        CurrPage.WhseMovLines.Page.DeleteQtyToHandle;
    end;

    local procedure RegisterActivityYesNo()
    begin
        CurrPage.WhseMovLines.Page.RegisterActivityYesNo;
    end;

    local procedure SortingMethodOnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure BreakbulkFilterOnAfterValidate()
    begin
        CurrPage.Update;
    end;
}

