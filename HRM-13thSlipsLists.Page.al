#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 99026 "HRM-13thSlips Lists"
{
    CardPageID = "HRM-Employee (B)";
    DeleteAllowed = true;
    Editable = false;
    PageType = List;
    SourceTable = UnknownTable61188;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                }
                field("First Name";"First Name")
                {
                    ApplicationArea = Basic;
                }
                field("Middle Name";"Middle Name")
                {
                    ApplicationArea = Basic;
                }
                field("Last Name";"Last Name")
                {
                    ApplicationArea = Basic;
                }
                field(Gender;Gender)
                {
                    ApplicationArea = Basic;
                }
                field(Initials;Initials)
                {
                    ApplicationArea = Basic;
                }
                field("Search Name";"Search Name")
                {
                    ApplicationArea = Basic;
                }
                field("Postal Address";"Postal Address")
                {
                    ApplicationArea = Basic;
                }
                field(City;City)
                {
                    ApplicationArea = Basic;
                }
                field("Post Code";"Post Code")
                {
                    ApplicationArea = Basic;
                }
                field("Ext.";"Ext.")
                {
                    ApplicationArea = Basic;
                }
                field("E-Mail";"E-Mail")
                {
                    ApplicationArea = Basic;
                }
                field("ID Number";"ID Number")
                {
                    ApplicationArea = Basic;
                }
                field(DateOfBirth;DateOfBirth)
                {
                    ApplicationArea = Basic;
                }
                field(DateEngaged;DateEngaged)
                {
                    ApplicationArea = Basic;
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    var
        PictureExists: Boolean;
        CheckList: Codeunit "HR CheckList";
        ACheckListTable: Record UnknownRecord61246;
        SICNumbersTable: Record UnknownRecord61236;
        SICNumbersList: Codeunit "HR SIC Numbers";
        Dates: Codeunit "HR Dates";
        "gOpt Active": Option Active,Archive,All;
        D: Date;
        DAge: Text[100];
        DService: Text[100];
        DPension: Text[100];
        DMedical: Text[100];
        [InDataSet]
        "Disabling DetailsEditable": Boolean;
        [InDataSet]
        "Disability GradeEditable": Boolean;
        FrmCalendar: Page "GEN--Calendar Small";
        "FORM HR Employee": Page "HRM-Employee-List";
        HREmp: Record UnknownRecord61188;
        RetirementDur: Text[250];
        DoclLink: Record UnknownRecord61224;
        "Filter": Boolean;
        prEmployees: Record UnknownRecord61118;
        prPayrollType: Record UnknownRecord61103;
        Mail: Codeunit Mail;
        SupervisorNames: Text[30];
        HRValueChange: Record UnknownRecord61206;
        Dretirement: Text;
        DRetire: Text;
        Text19004462: label 'Union Worker?';
        Text19012299: label 'Per Week';


    procedure "Filter Employees"(Type: Option Active,Archive,All)
    begin
          if Type = Type::Active then begin
             Reset;
             SetFilter("Termination Category",'=%1',"termination category"::" ");
            end
           else
         if Type = Type::Archive then begin
             Reset;
             SetFilter("Termination Category",'<>%1',"termination category"::" ");
            end
           else
         if Type = Type::All then
            Reset;

         CurrPage.Update(false);
         FilterGroup(20);
    end;

    local procedure ActivegOptActiveOnPush()
    begin
          "Filter Employees"(0); //Active Employees
    end;

    local procedure ArchivegOptActiveOnPush()
    begin
          "Filter Employees"(1); //Archived Employees
    end;

    local procedure AllgOptActiveOnPush()
    begin
          "Filter Employees"(2); //  Show All Employees
    end;

    local procedure ActivegOptActiveOnValidate()
    begin
        ActivegOptActiveOnPush;
    end;

    local procedure ArchivegOptActiveOnValidate()
    begin
        ArchivegOptActiveOnPush;
    end;

    local procedure AllgOptActiveOnValidate()
    begin
        AllgOptActiveOnPush;
    end;
}

