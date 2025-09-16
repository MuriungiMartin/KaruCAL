#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5986 "Service Item Component List"
{
    AutoSplitKey = true;
    Caption = 'Service Item Component List';
    DataCaptionFields = "Parent Service Item No.","Line No.";
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Service Item Component";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Parent Service Item No.";"Parent Service Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the service item in which the component is included.';
                    Visible = false;
                }
                field("Line No.";"Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the line.';
                    Visible = false;
                }
                field(Active;Active)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that the component is in use.';
                    Visible = false;
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the component type.';
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of an item or a service item, based on the value in the Type field.';
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the variant code of the component.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the component.';
                }
                field("Serial No.";"Serial No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the serial number of the component.';

                    trigger OnAssistEdit()
                    begin
                        AssistEditSerialNo;
                    end;
                }
                field("Date Installed";"Date Installed")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the component was installed.';
                }
                field("From Line No.";"From Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the line number assigned to the component when it was an active component of the service item.';
                    Visible = false;
                }
                field("Last Date Modified";"Last Date Modified")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the component was last modified.';
                    Visible = false;
                }
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
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Com&ponent")
            {
                Caption = 'Com&ponent';
                Image = Components;
                action("&Copy from BOM")
                {
                    ApplicationArea = Basic;
                    Caption = '&Copy from BOM';
                    Image = CopyFromBOM;

                    trigger OnAction()
                    begin
                        ServItem.Get("Parent Service Item No.");
                        Codeunit.Run(Codeunit::"ServComponent-Copy from BOM",ServItem);
                    end;
                }
                group("&Replaced List")
                {
                    Caption = '&Replaced List';
                    Image = ItemSubstitution;
                    action(ThisLine)
                    {
                        ApplicationArea = Basic;
                        Caption = 'This Line';
                        Image = Line;
                        RunObject = Page "Replaced Component List";
                        RunPageLink = Active=const(false),
                                      "Parent Service Item No."=field("Parent Service Item No."),
                                      "From Line No."=field("Line No.");
                        RunPageView = sorting(Active,"Parent Service Item No.","From Line No.");
                    }
                    action(AllLines)
                    {
                        ApplicationArea = Basic;
                        Caption = 'All Lines';
                        Image = AllLines;
                        RunObject = Page "Replaced Component List";
                        RunPageLink = Active=const(false),
                                      "Parent Service Item No."=field("Parent Service Item No.");
                        RunPageView = sorting(Active,"Parent Service Item No.","From Line No.");
                    }
                }
            }
        }
    }

    var
        ServItem: Record "Service Item";
}

