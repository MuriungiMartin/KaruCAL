#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7399 "Internal Movement"
{
    Caption = 'Internal Movement';
    PageType = Document;
    PopulateAllFields = true;
    RefreshOnActivate = true;
    SourceTable = "Internal Movement Header";

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
                    ToolTip = 'There are a number of tables and fields that are not currently documented. There is no specific Help for these tables and fields.';

                    trigger OnAssistEdit()
                    begin
                        if AssistEdit then
                          CurrPage.Update;
                    end;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the location where the internal movement is being performed.';
                }
                field("To Bin Code";"To Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the bin where you want items on this internal movement to be placed when they are picked.';
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'There are a number of tables and fields that are not currently documented. There is no specific Help for these tables and fields.';
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
                    ToolTip = 'There are a number of tables and fields that are not currently documented. There is no specific Help for these tables and fields.';
                }
                field("Assignment Time";"Assignment Time")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'There are a number of tables and fields that are not currently documented. There is no specific Help for these tables and fields.';
                }
                field("Sorting Method";"Sorting Method")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the method by which the internal movements are sorted.';

                    trigger OnValidate()
                    begin
                        SortingMethodOnAfterValidate;
                    end;
                }
            }
            part(InternalMovementLines;"Internal Movement Subform")
            {
                SubPageLink = "No."=field("No.");
                SubPageView = sorting("No.","Sorting Sequence No.");
            }
        }
        area(factboxes)
        {
            part(Control5;"Lot Numbers by Bin FactBox")
            {
                Provider = InternalMovementLines;
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
            group("&Internal Movement")
            {
                Caption = '&Internal Movement';
                Image = CreateMovement;
                action(List)
                {
                    ApplicationArea = Basic;
                    Caption = 'List';
                    Image = OpportunitiesList;
                    ShortCutKey = 'Shift+Ctrl+L';

                    trigger OnAction()
                    begin
                        LookupInternalMovementHeader(Rec);
                    end;
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Warehouse Comment Sheet";
                    RunPageLink = "Table Name"=const("Internal Movement"),
                                  Type=const(" "),
                                  "No."=field("No.");
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Get Bin Content")
                {
                    AccessByPermission = TableData "Bin Content"=R;
                    ApplicationArea = Basic;
                    Caption = 'Get Bin Content';
                    Ellipsis = true;
                    Image = GetBinContent;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        BinContent: Record "Bin Content";
                        WhseGetBinContent: Report "Whse. Get Bin Content";
                    begin
                        TestField("No.");
                        TestField("Location Code");
                        BinContent.SetRange("Location Code","Location Code");
                        WhseGetBinContent.SetTableview(BinContent);
                        WhseGetBinContent.InitializeInternalMovement(Rec);
                        WhseGetBinContent.Run;
                    end;
                }
                separator(Action34)
                {
                }
                action("Create Inventory Movement")
                {
                    ApplicationArea = Basic;
                    Caption = 'Create Inventory Movement';
                    Ellipsis = true;
                    Image = CreatePutAway;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        CreateInvtPickMovement: Codeunit "Create Inventory Pick/Movement";
                    begin
                        CreateInvtPickMovement.CreateInvtMvntWithoutSource(Rec);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        OpenInternalMovementHeader(Rec);
    end;

    local procedure SortingMethodOnAfterValidate()
    begin
        CurrPage.Update;
    end;
}

