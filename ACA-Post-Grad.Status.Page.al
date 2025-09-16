#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68802 "ACA-Post-Grad. Status"
{
    PageType = Card;
    SourceTable = UnknownTable61549;

    layout
    {
        area(content)
        {
            field("Programme Filter";"Programme Filter")
            {
                ApplicationArea = Basic;

                trigger OnValidate()
                begin
                    
                    /*SETFILTER("Stage Filter",'');
                    //SETFILTER("Unit Filter",'');
                    //SETFILTER("Semester Filter",'');
                    SETRANGE(Programme,GETFILTER("Programme Filter"));
                    NoStud:=0;
                    PName:='';
                    SName:='';
                    UName:='';
                    IF Prog.GET(GETFILTER("Programme Filter")) THEN
                    PName:=Prog.Description;
                    
                    
                    ProgStages.RESET;
                    ProgStages.SETRANGE(ProgStages."Programme Code",GETFILTER("Programme Filter"));
                    IF ProgStages.FIND('-') THEN BEGIN
                    SETFILTER("Stage Filter",ProgStages.Code);
                    //VALIDATE("Stage Filter");
                    SETFILTER("Unit Filter",'');
                    SETRANGE(Stage,GETFILTER("Stage Filter"));
                    NoStud:=0;
                    SName:='';
                    UName:='';
                    
                    
                    IF StageR.GET(GETFILTER("Programme Filter"),GETFILTER("Stage Filter")) THEN
                    SName:=StageR.Description;
                    
                    END;
                    
                    PSemester.RESET;
                    PSemester.SETRANGE(PSemester."Programme Code",GETFILTER("Programme Filter"));
                    PSemester.SETRANGE(PSemester.Current,TRUE);
                    IF PSemester.FIND('-') THEN BEGIN
                    SETFILTER("Semester Filter",PSemester.Semester);
                    VALIDATE("Semester Filter");
                    SETRANGE(Semester,GETFILTER("Semester Filter"));
                    
                    END;
                    */
                    
                    SetFilter(Semester,GetFilter("Semester Filter"));
                    SetFilter(Stage,GetFilter("Stage Filter"));
                    SetFilter(Programme,GetFilter("Programme Filter"));
                    SetFilter(Unit,GetFilter("Unit Filter"));
                    if Prog.Get(GetFilter("Programme Filter")) then
                    PName:=Prog.Description;
                    
                    if Count=0 then Error('No Student found within the filters');

                end;
            }
            field(PName;PName)
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field("Unit Filter";"Unit Filter")
            {
                ApplicationArea = Basic;

                trigger OnValidate()
                begin
                    //RESET;
                    SetFilter(Semester,GetFilter("Semester Filter"));
                    SetFilter(Stage,GetFilter("Stage Filter"));
                    SetFilter(Programme,GetFilter("Programme Filter"));
                    SetFilter(Unit,GetFilter("Unit Filter"));
                    
                    
                    /*
                    SETRANGE(Unit,GETFILTER("Unit Filter"));
                    NoStud:=0;
                    CreditH:=0;
                    Units.RESET;
                    Units.SETRANGE(Units."Programme Code",Units.GETFILTER(Units."Programme Filter"));
                    //Units.SETRANGE(Units."Stage Code",Units.GETFILTER(Units."Stage Filter"));
                    Units.SETRANGE(Units.Code,Units.GETFILTER(Units."Unit Filter"));
                    IF Units.FIND('-') THEN BEGIN
                    Units.CALCFIELDS(Units."Students Registered");
                    NoStud:=Units."Students Registered";
                    END;
                    UName:='';
                    NoStud:=0;
                    UnitsR.RESET;
                    UnitsR.SETRANGE(UnitsR."Programme Code",GETFILTER("Programme Filter"));
                    UnitsR.SETRANGE(UnitsR.Code,GETFILTER("Unit Filter"));
                    IF UnitsR.FIND('-') THEN BEGIN
                    UnitsR.CALCFIELDS(UnitsR."Students Registered");
                    UName:=UnitsR.Desription;
                    CreditH:=UnitsR."Credit Hours";
                    //NoStud:=UnitsR."Students Registered";
                    END;
                    */

                end;
            }
            field(UName;UName)
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field(Lect;Lect)
            {
                ApplicationArea = Basic;
                Caption = 'Lecturer';
                Editable = false;
            }
            field("Semester Filter";"Semester Filter")
            {
                ApplicationArea = Basic;

                trigger OnValidate()
                begin
                    //RESET;
                    SetFilter(Semester,GetFilter("Semester Filter"));
                    SetFilter(Stage,GetFilter("Stage Filter"));
                    SetFilter(Programme,GetFilter("Programme Filter"));
                    SetFilter(Unit,GetFilter("Unit Filter"));
                    
                    /*SETRANGE(Semester,GETFILTER("Semester Filter"));
                    
                    //TTable.SETRANGE(TTable.Semester,GETFILTER("Semester Filter"));
                    UnitsR.RESET;
                    UnitsR.SETRANGE(UnitsR."Programme Code",GETFILTER("Programme Filter"));
                    UnitsR.SETRANGE(UnitsR."Stage Code",GETFILTER("Stage Filter"));
                    UnitsR.SETRANGE(UnitsR.Code,GETFILTER("Unit Filter"));
                    UnitsR.SETFILTER(UnitsR."Semester Filter",GETFILTER("Semester Filter"));
                    IF UnitsR.FIND('-') THEN BEGIN
                    UnitsR.CALCFIELDS(UnitsR."Students Registered");
                    NoStud:=UnitsR."Students Registered";
                    END;
                    
                    {SETRANGE(Semester,GETFILTER("Semester Filter"));
                    
                    //TTable.SETRANGE(TTable.Semester,GETFILTER("Semester Filter"));
                    UnitsR.RESET;
                    UnitsR.SETRANGE(UnitsR."Programme Code",GETFILTER("Programme Filter"));
                    UnitsR.SETRANGE(UnitsR."Stage Code",GETFILTER("Stage Filter"));
                    UnitsR.SETRANGE(UnitsR.Code,GETFILTER("Unit Filter"));
                    UnitsR.SETFILTER(UnitsR."Semester Filter",GETFILTER("Semester Filter"));
                    IF UnitsR.FIND('-') THEN BEGIN
                    UnitsR.CALCFIELDS(UnitsR."Students Registered");
                    NoStud:=UnitsR."Students Registered";
                    END;
                    
                    Lect:='';
                    
                    LecUnits.RESET;
                    LecUnits.SETRANGE(LecUnits.Programme,GETFILTER("Programme Filter"));
                    LecUnits.SETRANGE(LecUnits.Stage,GETFILTER("Stage Filter"));
                    LecUnits.SETRANGE(LecUnits.Unit,GETFILTER("Unit Filter"));
                    LecUnits.SETRANGE(LecUnits.Semester,GETFILTER("Semester Filter"));
                    IF LecUnits.FIND('-') THEN BEGIN
                    IF Employee.GET(LecUnits.Lecturer) THEN
                    Lect:=Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name";
                    END;
                     }
                    */

                end;
            }
            field("Stage Filter";"Stage Filter")
            {
                ApplicationArea = Basic;

                trigger OnValidate()
                begin
                    //RESET;
                    SetFilter(Semester,GetFilter("Semester Filter"));
                    SetFilter(Stage,GetFilter("Stage Filter"));
                    SetFilter(Programme,GetFilter("Programme Filter"));
                    SetFilter(Unit,GetFilter("Unit Filter"));
                    
                    /*
                    SETFILTER("Unit Filter",'');
                    SETRANGE(Stage,GETFILTER("Stage Filter"));
                    NoStud:=0;
                    {
                    CurrForm.Matrix.MatrixRec.RESET;
                    CurrForm.Matrix.MatrixRec.SETRANGE(CurrForm.Matrix.MatrixRec."Programme Code",Programme);
                    CurrForm.Matrix.MatrixRec.SETRANGE(CurrForm.Matrix.MatrixRec."Stage Code",Stage);
                    }
                    SName:='';
                    UName:='';
                    
                    IF StageR.GET(GETFILTER("Programme Filter"),GETFILTER("Stage Filter")) THEN
                    SName:=StageR.Description;
                    */

                end;
            }
            repeater(Control1102760000)
            {
                field("Student No.";"Student No.")
                {
                    ApplicationArea = Basic;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    Caption = 'Names';
                    Editable = false;
                }
                field("Proposal Status";"Proposal Status")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                         if not Confirm('Do you really want to change the proposal status?') then
                         "Proposal Status":=xRec."Proposal Status";
                    end;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Caption = 'Thesis Status';

                    trigger OnValidate()
                    begin
                         if not Confirm('Do you really want to change the thesis status?') then
                         Status:=xRec.Status;
                    end;
                }
                field("Project Status";"Project Status")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                         if not Confirm('Do you really want to change the project status?') then
                         "Project Status":=xRec."Project Status";
                    end;
                }
                field("Progress Report";"Progress Report")
                {
                    ApplicationArea = Basic;
                }
                field("Details Count";"Details Count")
                {
                    ApplicationArea = Basic;
                }
                field("Proposal Date";"Proposal Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field("Senate-Proposal";"Senate-Proposal")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Research;Research)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Senate-Research";"Senate-Research")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Examiners;Examiners)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Defense;Defense)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Defence OutCome";"Defence OutCome")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Remarks;Remarks)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        Name:='';
        if Students.Get("Student No.") then
        Name:=Students.Name + ' ' + Students."Name 2"
        else
        Name:='';
    end;

    trigger OnOpenPage()
    begin
        SetFilter("Programme Filter",'');
        SetFilter("Stage Filter",'');
        SetFilter("Unit Filter",'');
        SetFilter("Semester Filter",'');
        Reset;
    end;

    var
        Name: Text[250];
        Students: Record Customer;
        Sem: Text[100];
        NoStud: Integer;
        Units: Record UnknownRecord61517;
        PName: Text[250];
        SName: Text[250];
        UName: Text[250];
        Prog: Record UnknownRecord61511;
        StageR: Record UnknownRecord61516;
        UnitsR: Record UnknownRecord61517;
        LUnits: Record UnknownRecord61541;
        Lect: Text[250];
        Employee: Record UnknownRecord61188;
        ExamsSetup: Record UnknownRecord61567;
        CreditH: Decimal;
        LecUnits: Record UnknownRecord61541;
        LecUnitsTaken: Record UnknownRecord61541;
        ProgStages: Record UnknownRecord61516;
        PSemester: Record UnknownRecord61525;
}

