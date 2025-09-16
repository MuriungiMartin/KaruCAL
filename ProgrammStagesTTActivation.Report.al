#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51721 "Programm Stages TT Activation"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Programm Stages TT Activation.rdlc';

    dataset
    {
        dataitem(UnknownTable61516;UnknownTable61516)
        {
            RequestFilterFields = "Programme Code","Code";
            column(ReportForNavId_1; 1)
            {
            }
            column(ProgrammeCode_ProgrammeStages;"ACA-Programme Stages"."Programme Code")
            {
            }
            column(Code_ProgrammeStages;"ACA-Programme Stages".Code)
            {
            }
            column(Description_ProgrammeStages;"ACA-Programme Stages".Description)
            {
            }
            column(Department_ProgrammeStages;"ACA-Programme Stages".Department)
            {
            }

            trigger OnAfterGetRecord()
            begin

                   if ActionX=Actionx::Include then
                   "ACA-Programme Stages"."Include in Time Table":=true
                   else
                   "ACA-Programme Stages"."Include in Time Table":=false;
                   "ACA-Programme Stages".Modify;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(ActionX;ActionX)
                {
                    ApplicationArea = Basic;
                    Caption = 'Action Type';
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        ActionX: Option Include,Clear;
}

