#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9509 "Debugger Break Rules"
{
    Caption = 'Debugger Break Rules';
    PageType = StandardDialog;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(BreakOnError;BreakOnError)
                {
                    ApplicationArea = All;
                    Caption = 'Break On Error';
                }
                field(BreakOnRecordChanges;BreakOnRecordChanges)
                {
                    ApplicationArea = All;
                    Caption = 'Break On Record Changes';
                }
                field(SkipCodeunit1;SkipCodeunit1)
                {
                    ApplicationArea = All;
                    Caption = 'Skip Codeunit 1';
                }
            }
        }
    }

    actions
    {
    }

    var
        BreakOnError: Boolean;
        BreakOnRecordChanges: Boolean;
        SkipCodeunit1: Boolean;


    procedure SetBreakOnError(Value: Boolean)
    begin
        BreakOnError := Value;
    end;


    procedure GetBreakOnError(): Boolean
    begin
        exit(BreakOnError);
    end;


    procedure SetBreakOnRecordChanges(Value: Boolean)
    begin
        BreakOnRecordChanges := Value;
    end;


    procedure GetBreakOnRecordChanges(): Boolean
    begin
        exit(BreakOnRecordChanges);
    end;


    procedure SetSkipCodeunit1(Value: Boolean)
    begin
        SkipCodeunit1 := Value;
    end;


    procedure GetSkipCodeunit1(): Boolean
    begin
        exit(SkipCodeunit1);
    end;
}

