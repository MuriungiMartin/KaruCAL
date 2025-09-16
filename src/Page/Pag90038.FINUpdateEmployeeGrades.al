#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 90038 "FIN-Update Employee Grades"
{
    ApplicationArea = Basic;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = UnknownTable61118;
    SourceTableView = where(Status=filter(Normal),
                            "PT Category"=filter(<>PT));
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Salary Category";"Salary Category")
                {
                    ApplicationArea = Basic;
                }
                field("Salary Grade";"Salary Grade")
                {
                    ApplicationArea = Basic;
                }
                field("First Name";"First Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Middle Name";"Middle Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Last Name";"Last Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(ImpGrades)
            {
                ApplicationArea = Basic;
                Caption = 'Import Grades';
                Image = ImportCodes;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Confirm('Import Grades?',true)=false then Error('Importation Cancelled by user!');
                    if Confirm('Your excel file should be in the following format:\Pf. No.\Category\Grade\ \ \....Formats....\ i. CSV\ ii. txt',true)=true then;
                    if Confirm('Choose your file.',true) then;
                    Xmlport.Run(50211,false,true);
                end;
            }
        }
    }
}

