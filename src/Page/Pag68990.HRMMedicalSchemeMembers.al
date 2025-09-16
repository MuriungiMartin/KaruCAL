#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68990 "HRM-Medical Scheme Members"
{
    PageType = Card;
    SourceTable = "HRM-Medical Schemes";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Scheme No";"Scheme No")
                {
                    ApplicationArea = Basic;
                }
                field("Scheme Name";"Scheme Name")
                {
                    ApplicationArea = Basic;
                }
                field("Medical Insurer";"Medical Insurer")
                {
                    ApplicationArea = Basic;
                }
                field("In-patient limit";"In-patient limit")
                {
                    ApplicationArea = Basic;
                }
                field("Out-patient limit";"Out-patient limit")
                {
                    ApplicationArea = Basic;
                }
                field("Area Covered";"Area Covered")
                {
                    ApplicationArea = Basic;
                }
                field("Insurer Name";"Insurer Name")
                {
                    ApplicationArea = Basic;
                }
                field(Comments;Comments)
                {
                    ApplicationArea = Basic;
                }
                field("Dependants Included";"Dependants Included")
                {
                    ApplicationArea = Basic;
                }
                field("Maximum No of Dependants";"Maximum No of Dependants")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        if Dependants."No of Depnedants" >Dependants."Maximum No of dependants" then
        begin
            Error('No. of dependants cannot exceedd the required number');
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        if Dependants."No of Depnedants" >Dependants."Maximum No of dependants" then
        begin
            Error('No. of dependants cannot exceedd the required number');
        end;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        if Dependants."No of Depnedants" >Dependants."Maximum No of dependants" then
        begin
            Error('No. of dependants cannot exceedd the required number');
        end;
    end;

    var
        Dependants: Record "HRM-Medical Scheme Members";
}

