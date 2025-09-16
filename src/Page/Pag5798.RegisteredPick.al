#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5798 "Registered Pick"
{
    Caption = 'Registered Pick';
    InsertAllowed = false;
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "Registered Whse. Activity Hdr.";
    SourceTableView = where(Type=const(Pick));

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
                    Editable = false;
                    ToolTip = 'Specifies the registered warehouse activity number.';
                }
                field("Whse. Activity No.";"Whse. Activity No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the warehouse activity number from which the activity was registered.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the code of the location in which the registered warehouse activity occurred.';
                }
                field("Registering Date";"Registering Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'This object supports the program infrastructure and is intended for internal use.';
                }
                field("Assigned User ID";"Assigned User ID")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the ID of the employee who is responsible for the document and assigned to perform the warehouse activity.';
                }
                field("Assignment Date";"Assignment Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the date the user was assigned the activity.';
                }
                field("Assignment Time";"Assignment Time")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the time of day the user was assigned the activity.';
                }
                field("Sorting Method";"Sorting Method")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the method by which the lines were sorted on the warehouse header, such as by item, or bin code.';
                }
                field("No. Printed";"No. Printed")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the number of times the warehouse activity has been printed.';
                }
            }
            part(WhseActivityLines;"Registered Pick Subform")
            {
                SubPageLink = "Activity Type"=field(Type),
                              "No."=field("No.");
                SubPageView = sorting("Activity Type","No.","Sorting Sequence No.");
            }
        }
        area(factboxes)
        {
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
            group("P&ick")
            {
                Caption = 'P&ick';
                Image = CreateInventoryPickup;
                action(List)
                {
                    ApplicationArea = Basic;
                    Caption = 'List';
                    Image = OpportunitiesList;
                    ShortCutKey = 'Shift+Ctrl+L';

                    trigger OnAction()
                    begin
                        LookupRegisteredActivityHeader("Location Code",Rec);
                    end;
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Warehouse Comment Sheet";
                    RunPageLink = "Table Name"=const("Rgstrd. Whse. Activity Header"),
                                  Type=field(Type),
                                  "No."=field("No.");
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetWhseLocationFilter;
    end;
}

