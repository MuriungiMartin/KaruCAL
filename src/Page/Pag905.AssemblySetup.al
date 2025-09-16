#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 905 "Assembly Setup"
{
    ApplicationArea = Basic;
    Caption = 'Assembly Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Assembly Setup";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Stockout Warning";"Stockout Warning")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether the assembly availability warning appears during sales order entry.';
                }
                field("Copy Component Dimensions from";"Copy Component Dimensions from")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Defines how dimension codes are distributed to assembly components when they are consumed in assembly order posting.';
                }
                field("Default Location for Orders";"Default Location for Orders")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies at which location assembly orders are created by default.';
                }
                field("Copy Comments when Posting";"Copy Comments when Posting")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'There are a number of tables and fields that are not currently documented. There is no specific Help for these tables and fields.';
                }
            }
            group(Numbering)
            {
                Caption = 'Numbering';
                field("Assembly Order Nos.";"Assembly Order Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number series code used to assign numbers to assembly orders when they are created.';
                }
                field("Assembly Quote Nos.";"Assembly Quote Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number series code used to assign numbers to assembly quotes when they are created.';
                }
                field("Blanket Assembly Order Nos.";"Blanket Assembly Order Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number series code used to assign numbers to assembly blanket orders when they are created.';
                }
                field("Posted Assembly Order Nos.";"Posted Assembly Order Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number series code used to assign numbers to assembly orders when they are posted.';
                }
            }
            group(Warehouse)
            {
                Caption = 'Warehouse';
                field("Create Movements Automatically";"Create Movements Automatically")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that an inventory movement for the required components is created automatically when you create an inventory pick.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Reset;
        if not Get then begin
          Init;
          Insert;
        end;
    end;
}

