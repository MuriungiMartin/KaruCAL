#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7382 "Inventory Movement"
{
    Caption = 'Inventory Movement';
    PageType = Document;
    RefreshOnActivate = true;
    SaveValues = true;
    SourceTable = "Warehouse Activity Header";
    SourceTableView = where(Type=const("Invt. Movement"));

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
                    ToolTip = 'Specifies the number of the warehouse header.';

                    trigger OnAssistEdit()
                    begin
                        if AssistEdit(xRec) then
                          CurrPage.Update;
                    end;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the location where the warehouse activity takes place.';
                }
                field(Control15;"Source Document")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    Lookup = false;
                    OptionCaption = '  ,,,,,,,,,,,Prod. Consumption,,,,,,,,,Assembly Consumption';
                    ToolTip = 'Specifies the type of document to which the line relates, including sales order, purchase order, or transfer order.';
                }
                field("Source No.";"Source No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the source document from which the activity originated.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        CreateInvtPickMovement: Codeunit "Create Inventory Pick/Movement";
                    begin
                        if LineExist then
                          Error(Text001);

                        CreateInvtPickMovement.SetInvtMovement(true);
                        CreateInvtPickMovement.Run(Rec);
                        CurrPage.Update;
                        CurrPage.WhseActivityLines.Page.UpdateForm;
                    end;

                    trigger OnValidate()
                    begin
                        SourceNoOnAfterValidate;
                    end;
                }
                field("Destination No.";"Destination No.")
                {
                    ApplicationArea = Basic;
                    CaptionClass = FORMAT(WMSMgt.GetCaption("Destination Type","Source Document",0));
                    Editable = false;
                    ToolTip = 'Specifies the number or the code of the customer or vendor that the line is linked to.';
                }
                field("WMSMgt.GetDestinationName(""Destination Type"",""Destination No."")";WMSMgt.GetDestinationName("Destination Type","Destination No."))
                {
                    ApplicationArea = Basic;
                    CaptionClass = FORMAT(WMSMgt.GetCaption("Destination Type","Source Document",1));
                    Caption = 'Name';
                    Editable = false;
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the warehouse activity should be recorded as being posted.';
                }
                field("External Document No.";"External Document No.")
                {
                    ApplicationArea = Basic;
                    CaptionClass = FORMAT(WMSMgt.GetCaption("Destination Type","Source Document",2));
                    ToolTip = 'Specifies the external document number for the source document to which the warehouse activity is related.';
                }
                field("External Document No.2";"External Document No.2")
                {
                    ApplicationArea = Basic;
                    CaptionClass = FORMAT(WMSMgt.GetCaption("Destination Type","Source Document",3));
                    ToolTip = 'Specifies an additional external document number for the inventory put-away or inventory pick.';
                }
                field("Sorting Method";"Sorting Method")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the method by which the lines are sorted on the warehouse header, such as Item or Document.';

                    trigger OnValidate()
                    begin
                        SortingMethodOnAfterValidate;
                    end;
                }
            }
            part(WhseActivityLines;"Invt. Movement Subform")
            {
                SubPageLink = "Activity Type"=field(Type),
                              "No."=field("No.");
                SubPageView = sorting("Activity Type","No.","Sorting Sequence No.")
                              where(Breakbulk=const(false));
            }
        }
        area(factboxes)
        {
            part(Control3;"Lot Numbers by Bin FactBox")
            {
                Provider = WhseActivityLines;
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
                        LookupActivityHeader("Location Code",Rec);
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
                action("Registered Invt. Movements")
                {
                    ApplicationArea = Basic;
                    Caption = 'Registered Invt. Movements';
                    Image = RegisteredDocs;
                    RunObject = Page "Registered Invt. Movement List";
                    RunPageLink = "Invt. Movement No."=field("No.");
                    RunPageView = sorting("Invt. Movement No.");
                }
                action("Source Document")
                {
                    ApplicationArea = Basic;
                    Caption = 'Source Document';
                    Image = "Order";

                    trigger OnAction()
                    var
                        WMSMgt: Codeunit "WMS Management";
                    begin
                        WMSMgt.ShowSourceDocCard("Source Type","Source Subtype","Source No.");
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(GetSourceDocument)
                {
                    ApplicationArea = Basic;
                    Caption = '&Get Source Document';
                    Ellipsis = true;
                    Image = GetSourceDoc;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Ctrl+F7';

                    trigger OnAction()
                    var
                        CreateInvtPickMovement: Codeunit "Create Inventory Pick/Movement";
                    begin
                        if LineExist then
                          Error(Text001);
                        CreateInvtPickMovement.SetInvtMovement(true);
                        CreateInvtPickMovement.Run(Rec);
                    end;
                }
                action("Autofill Qty. to Handle")
                {
                    ApplicationArea = Basic;
                    Caption = 'Autofill Qty. to Handle';
                    Image = AutofillQtyToHandle;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        AutofillQtyToHandle;
                    end;
                }
                action("Delete Qty. to Handle")
                {
                    ApplicationArea = Basic;
                    Caption = 'Delete Qty. to Handle';
                    Image = DeleteQtyToHandle;

                    trigger OnAction()
                    begin
                        DeleteQtyToHandle;
                    end;
                }
            }
            group("&Registering")
            {
                Caption = '&Registering';
                Image = PostOrder;
                action("&Register Invt. Movement")
                {
                    ApplicationArea = Basic;
                    Caption = '&Register Invt. Movement';
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
                    WhseDocPrint.PrintInvtMovementHeader(Rec,false);
                end;
            }
        }
        area(reporting)
        {
            action("Movement List")
            {
                ApplicationArea = Basic;
                Caption = 'Movement List';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Movement List";
            }
        }
    }

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.Update;
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        exit(FindFirstAllowedRec(Which));
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Location Code" := xRec."Location Code";
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
        WhseDocPrint: Codeunit "Warehouse Document-Print";
        WMSMgt: Codeunit "WMS Management";
        Text001: label 'You cannot use this function if the lines already exist.';

    local procedure AutofillQtyToHandle()
    begin
        CurrPage.WhseActivityLines.Page.AutofillQtyToHandle;
    end;

    local procedure DeleteQtyToHandle()
    begin
        CurrPage.WhseActivityLines.Page.DeleteQtyToHandle;
    end;

    local procedure RegisterActivityYesNo()
    begin
        CurrPage.WhseActivityLines.Page.RegisterActivityYesNo;
    end;

    local procedure SourceNoOnAfterValidate()
    begin
        CurrPage.Update;
        CurrPage.WhseActivityLines.Page.UpdateForm;
    end;

    local procedure SortingMethodOnAfterValidate()
    begin
        CurrPage.Update;
    end;
}

