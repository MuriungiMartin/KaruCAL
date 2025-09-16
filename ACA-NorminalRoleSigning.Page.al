#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68238 "ACA-Norminal Role Signing"
{
    DelayedInsert = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = UnknownTable61532;

    layout
    {
        area(content)
        {
            group(Filters)
            {
                Caption = '&View Filters';
                field(AcadYear;AcadYear)
                {
                    ApplicationArea = Basic;
                    Caption = 'Academic Year';
                    TableRelation = "ACA-Academic Year".Code;

                    trigger OnValidate()
                    begin
                                    applyFilters();
                    end;
                }
                field(semester;semesterz1)
                {
                    ApplicationArea = Basic;
                    Caption = 'Semester Filter';
                    TableRelation = "ACA-Semesters".Code;

                    trigger OnValidate()
                    begin
                             if AcadYear='' then Error('Specify the Academic Year First!');
                             applyFilters();
                    end;
                }
            }
            repeater(Group)
            {
                field("Student No.";"Student No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Student Name";"Student Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Programme;Programme)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Stage;Stage)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Settlement Type";"Settlement Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Academic Year";"Academic Year")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Semester;Semester)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Total Billed";"Total Billed")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Gender;Gender)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Balance;Balance)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("First Time Student";"First Time Student")
                {
                    ApplicationArea = Basic;
                    Editable = true;

                    trigger OnValidate()
                    begin
                        if ((AcadYear='') or (semesterz1='')) then Error('Please specify the Academic Year and the Semester!');
                    end;
                }
                field("Fee Structure Exists";"Fee Structure Exists")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
         /*acadYearTable.RESET;
         acadYearTable.SETRANGE(acadYearTable.Current,TRUE);
         IF acadYearTable.FIND('-') THEN
         AcadYear:=acadYearTable.Code;
        
        SemTable.RESET;
        SemTable.SETRANGE(SemTable."Current Semester",TRUE);
        IF SemTable.FIND('-') THEN
        semesterz1:=SemTable.Code;
              */
        //IF ((AcadYear='') OR (semesterz1='')) THEN ERROR('The Academic Year and Semester setups are not done.')

    end;

    var
        AcadYear: Code[20];
        semesterz1: Code[20];
        acadYearTable: Record UnknownRecord61382;
        SemTable: Record UnknownRecord61692;


    procedure applyFilters()
    begin
        SetFilter("Academic Year",AcadYear);
        SetFilter(Semester,semesterz1);
        CurrPage.Update;
    end;
}

