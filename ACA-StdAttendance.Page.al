#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68801 "ACA-Std Attendance"
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
                    SetFilter("Stage Filter",'');
                    SetFilter("Unit Filter",'');
                    SetFilter("Semester Filter",'');
                    SetRange(Programme,GetFilter("Programme Filter"));
                    NoStud:=0;
                    PName:='';
                    SName:='';
                    UName:='';
                    if Prog.Get(GetFilter("Programme Filter")) then
                    PName:=Prog.Description;
                    
                    
                    ProgStages.Reset;
                    ProgStages.SetRange(ProgStages."Programme Code",GetFilter("Programme Filter"));
                    if ProgStages.Find('-') then begin
                    SetFilter("Stage Filter",ProgStages.Code);
                    Validate("Stage Filter");
                    SetFilter("Unit Filter",'');
                    SetRange(Stage,GetFilter("Stage Filter"));
                    NoStud:=0;
                    SName:='';
                    UName:='';
                    
                    if StageR.Get(GetFilter("Programme Filter"),GetFilter("Stage Filter")) then
                    SName:=StageR.Description;
                    
                    end;
                    
                    /*
                    PSemester.RESET;
                    PSemester.SETRANGE(PSemester."Programme Code",GETFILTER("Programme Filter"));
                    PSemester.SETRANGE(PSemester.Current,TRUE);
                    IF PSemester.FIND('-') THEN BEGIN
                    SETFILTER("Semester Filter",PSemester.Semester);
                    VALIDATE("Semester Filter");
                    SETRANGE(Semester,GETFILTER("Semester Filter"));
                    
                    END;
                    */

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
                    SetRange(Unit,GetFilter("Unit Filter"));
                    NoStud:=0;
                    CreditH:=0;
                    Units.Reset;
                    Units.SetRange(Units."Programme Code",Units.GetFilter(Units."Programme Filter"));
                    //Units.SETRANGE(Units."Stage Code",Units.GETFILTER(Units."Stage Filter"));
                    Units.SetRange(Units.Code,Units.GetFilter(Units."Unit Filter"));
                    if Units.Find('-') then begin
                    Units.CalcFields(Units."Students Registered");
                    NoStud:=Units."Students Registered";
                    end;
                    UName:='';
                    NoStud:=0;
                    UnitsR.Reset;
                    UnitsR.SetRange(UnitsR."Programme Code",GetFilter("Programme Filter"));
                    UnitsR.SetRange(UnitsR.Code,GetFilter("Unit Filter"));
                    if UnitsR.Find('-') then begin
                    UnitsR.CalcFields(UnitsR."Students Registered");
                    UName:=UnitsR.Desription;
                    CreditH:=UnitsR."Credit Hours";
                    //NoStud:=UnitsR."Students Registered";
                    end;
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
            field(CreditH;CreditH)
            {
                ApplicationArea = Basic;
                Caption = 'Credit Hours';
                Editable = false;
            }
            field("Semester Filter";"Semester Filter")
            {
                ApplicationArea = Basic;

                trigger OnValidate()
                begin
                    SetRange(Semester,GetFilter("Semester Filter"));

                    //TTable.SETRANGE(TTable.Semester,GETFILTER("Semester Filter"));
                    UnitsR.Reset;
                    UnitsR.SetRange(UnitsR."Programme Code",GetFilter("Programme Filter"));
                    UnitsR.SetRange(UnitsR."Stage Code",GetFilter("Stage Filter"));
                    UnitsR.SetRange(UnitsR.Code,GetFilter("Unit Filter"));
                    UnitsR.SetFilter(UnitsR."Semester Filter",GetFilter("Semester Filter"));
                    if UnitsR.Find('-') then begin
                    UnitsR.CalcFields(UnitsR."Students Registered");
                    NoStud:=UnitsR."Students Registered";
                    end;

                    Lect:='';

                    LecUnits.Reset;
                    LecUnits.SetRange(LecUnits.Programme,GetFilter("Programme Filter"));
                    LecUnits.SetRange(LecUnits.Stage,GetFilter("Stage Filter"));
                    LecUnits.SetRange(LecUnits.Unit,GetFilter("Unit Filter"));
                    LecUnits.SetRange(LecUnits.Semester,GetFilter("Semester Filter"));
                    if LecUnits.Find('-') then begin
                    if Employee.Get(LecUnits.Lecturer) then
                    Lect:=Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name";
                    end;
                end;
            }
            field("Stage Filter";"Stage Filter")
            {
                ApplicationArea = Basic;

                trigger OnValidate()
                begin
                    SetFilter("Unit Filter",'');
                    SetRange(Stage,GetFilter("Stage Filter"));
                    NoStud:=0;
                    /*
                    CurrForm.Matrix.MatrixRec.RESET;
                    CurrForm.Matrix.MatrixRec.SETRANGE(CurrForm.Matrix.MatrixRec."Programme Code",Programme);
                    CurrForm.Matrix.MatrixRec.SETRANGE(CurrForm.Matrix.MatrixRec."Stage Code",Stage);
                    */
                    SName:='';
                    UName:='';
                    
                    if StageR.Get(GetFilter("Programme Filter"),GetFilter("Stage Filter")) then
                    SName:=StageR.Description;

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
                field(Attendance;Attendance)
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

