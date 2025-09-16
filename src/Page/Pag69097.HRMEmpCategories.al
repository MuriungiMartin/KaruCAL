#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69097 "HRM-Emp. Categories"
{
    Caption = 'Employee Categories';
    DataCaptionFields = "Code";
    PageType = List;
    SourceTable = UnknownTable61789;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(SalGrades)
            {
                ApplicationArea = Basic;
                Caption = 'Salary Grades';
                Image = StepInto;
                Promoted = true;
                RunObject = Page "HRM-Job_Salary Grade/Steps";
                RunPageLink = "Employee Category"=field(Code);
            }
        }
        area(processing)
        {
            group(Functions)
            {
                Caption = 'Imcreament';
                action("Increament Register")
                {
                    ApplicationArea = Basic;
                    Caption = 'Increament Register';
                    Image = Registered;
                    Promoted = true;
                    RunObject = Page "HRM-Salary Increament Register";
                }
                action("Un-Affected Employees")
                {
                    ApplicationArea = Basic;
                    Caption = 'Un-Affected Employees';
                    Image = History;
                    Promoted = true;
                    RunObject = Page "HRM-Unaffected Sal. Increament";
                }
                separator(Action9)
                {
                    Caption = 'History';
                }
                action(PostIncreament)
                {
                    ApplicationArea = Basic;
                    Caption = 'Post Salary Inrements';
                    Image = PostDocument;
                    Promoted = true;

                    trigger OnAction()
                    begin

                         Message('Please go through the Increment register \and ensure that the increments are right before posting.');
                          if Confirm('Are you sure you want to post salary increments?',false)=false then exit;
                         postReverse.postRegister();
                    end;
                }
                action(ReverseIncreament)
                {
                    ApplicationArea = Basic;
                    Caption = 'Reverse Salary Increments';
                    Image = ReverseRegister;
                    Promoted = true;

                    trigger OnAction()
                    begin

                          if Confirm('Reverse salary Increment postings?',false)=false then exit;
                        postReverse.ReverseInrementPosting();
                    end;
                }
                separator(Action14)
                {
                    Caption = 'Setup';
                }
                action("Salary Grade Setup")
                {
                    ApplicationArea = Basic;
                    Caption = 'Salary Grade Setup';
                    Image = SetupList;
                    Promoted = true;
                    RunObject = Page "HRM-Salary Grades List";
                }
            }
        }
        area(reporting)
        {
            action(Register)
            {
                ApplicationArea = Basic;
                Caption = 'Register';
                Image = Register;
                Promoted = true;
                RunObject = Report "HRM-Salary Increament Register";
            }
        }
    }

    var
        salGrades: Record UnknownRecord61790;
        salGrades2: Record UnknownRecord61790;
        salincregister: Record UnknownRecord61791;
        salincUnaffected: Record UnknownRecord61792;
        employees: Record UnknownRecord61118;
        salaryCate: Record UnknownRecord61789;
        EmplMonth: Integer;
        salaStepsAmount: Record UnknownRecord61793;
        salaStepsAmount2: Record UnknownRecord61793;
        empSalaryCard: Record UnknownRecord61105;
        unaffectedEmployees: Record UnknownRecord61792;
        salbasic: Decimal;
        salgrade: Code[20];
        salcat: Code[50];
        empcat: Record UnknownRecord61789;
        empgrade: Record UnknownRecord61061;
        postReverse: Codeunit "Post Salary Increments";
}

