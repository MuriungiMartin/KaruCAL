#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7357 "Whse. Internal Pick"
{
    Caption = 'Whse. Internal Pick';
    PageType = Document;
    PopulateAllFields = true;
    RefreshOnActivate = true;
    SourceTable = "Whse. Internal Pick Header";

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
                    ToolTip = 'Specifies the number of the warehouse internal pick header, created when you started to plan this internal pick.';

                    trigger OnAssistEdit()
                    begin
                        if AssistEdit(xRec) then
                          CurrPage.Update;
                    end;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the location where the internal pick is being performed.';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        CurrPage.SaveRecord;
                        LookupLocation(Rec);
                        CurrPage.Update(true);
                    end;
                }
                field("To Zone Code";"To Zone Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Indicates the zone in which you want the items to be placed when they are picked.';
                }
                field("To Bin Code";"To Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Indicates the bin in which you want the items to be placed when they are picked.';
                }
                field("Document Status";"Document Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the document status of the internal pick.';
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Indicates whether the internal pick is open or released.';
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the due date of the document.';
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
                    ToolTip = 'Specifies the date when the document was assigned to the user.';
                }
                field("Assignment Time";"Assignment Time")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the time when the document was assigned to the user.';
                }
                field("Sorting Method";"Sorting Method")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the method by which the warehouse internal pick lines are sorted.';

                    trigger OnValidate()
                    begin
                        SortingMethodOnAfterValidate;
                    end;
                }
            }
            part(WhseInternalPickLines;"Whse. Internal Pick Line")
            {
                SubPageLink = "No."=field("No.");
                SubPageView = sorting("No.","Sorting Sequence No.");
            }
        }
        area(factboxes)
        {
            part(Control6;"Lot Numbers by Bin FactBox")
            {
                Provider = WhseInternalPickLines;
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
            group("&Pick")
            {
                Caption = '&Pick';
                Image = CreateInventoryPickup;
                action(List)
                {
                    ApplicationArea = Basic;
                    Caption = 'List';
                    Image = OpportunitiesList;
                    ShortCutKey = 'Shift+Ctrl+L';

                    trigger OnAction()
                    begin
                        LookupWhseInternalPickHeader(Rec);
                    end;
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Warehouse Comment Sheet";
                    RunPageLink = "Table Name"=const("Internal Pick"),
                                  Type=const(" "),
                                  "No."=field("No.");
                }
                action("Pick Lines")
                {
                    ApplicationArea = Basic;
                    Caption = 'Pick Lines';
                    Image = PickLines;
                    RunObject = Page "Warehouse Activity Lines";
                    RunPageLink = "Whse. Document Type"=const("Internal Pick"),
                                  "Whse. Document No."=field("No.");
                    RunPageView = sorting("Whse. Document No.","Whse. Document Type","Activity Type")
                                  where("Activity Type"=const(Pick));
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Re&lease")
                {
                    ApplicationArea = Basic;
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    ShortCutKey = 'Ctrl+F9';

                    trigger OnAction()
                    var
                        ReleaseWhseInternalPick: Codeunit "Whse. Internal Pick Release";
                    begin
                        CurrPage.Update(true);
                        if Status = Status::Open then
                          ReleaseWhseInternalPick.Release(Rec);
                    end;
                }
                action("Re&open")
                {
                    ApplicationArea = Basic;
                    Caption = 'Re&open';
                    Image = ReOpen;

                    trigger OnAction()
                    var
                        ReleaseWhseInternalPick: Codeunit "Whse. Internal Pick Release";
                    begin
                        ReleaseWhseInternalPick.Reopen(Rec);
                    end;
                }
                separator(Action17)
                {
                }
                action(CreatePick)
                {
                    ApplicationArea = Basic;
                    Caption = 'Create Pick';
                    Ellipsis = true;
                    Image = CreateInventoryPickup;

                    trigger OnAction()
                    begin
                        CurrPage.Update(true);
                        CurrPage.WhseInternalPickLines.Page.PickCreate;
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetWhseLocationFilter;
    end;

    local procedure SortingMethodOnAfterValidate()
    begin
        CurrPage.Update;
    end;
}

