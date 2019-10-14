unit UnitMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  {��������Ԫ�Ǳ����}
  ComObj, ActiveX, ShlObj;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure CreateLink(ProgramPath, ProgramArg, LinkPath, Descr: String);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
const
  maxPath = 200; // ��������ַ������鳤��

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var

  tmp: array [0..maxPath] of Char;
  WinDir: string;
  pitem:PITEMIDLIST;
  usrDeskTopPath: string;
begin

  //��ȡ��ǰ�û������λ��
  SHGetSpecialFolderLocation(self.Handle, CSIDL_DESKTOP, pitem);
  setlength(usrDeskTopPath, maxPath);
  shGetPathFromIDList(pitem, PWideChar(usrDeskTopPath));
  usrDeskTopPath := String(PWideChar(usrDeskTopPath));

  // ������ݷ�ʽ
  CreateLink(
    ParamStr(0),                                       // Ӧ�ó�������·��
    '-22 -dd xx="aa"',                                 // ����Ӧ�ó���Ĳ���
    usrDeskTopPath + '\' + Application.Title + '.lnk', // ��ݷ�ʽ����·��
    'Application.Title'                                // ��ע
  );
end;
procedure TForm1.CreateLink(ProgramPath, ProgramArg, LinkPath, Descr: String);
var
  AnObj: IUnknown;
  ShellLink: IShellLink;
  AFile: IPersistFile;
  FileName: WideString;
begin
  if UpperCase(ExtractFileExt(LinkPath)) <> '.LNK' then //�����չ���Ƿ���ȷ
  begin
    raise Exception.Create('��ݷ�ʽ����չ�������� ���LNK���!');
    //������������쳣
  end;
try
  OleInitialize(nil);//��ʼ��OLE�⣬��ʹ��OLE����ǰ������ó�ʼ��
  AnObj := CreateComObject(CLSID_ShellLink); //���ݸ�����ClassID����
  //һ��COM���󣬴˴��ǿ�ݷ�ʽ
  ShellLink := AnObj as IShellLink;//ǿ��ת��Ϊ��ݷ�ʽ�ӿ�
  AFile := AnObj as IPersistFile;//ǿ��ת��Ϊ�ļ��ӿ�
  //���ÿ�ݷ�ʽ���ԣ��˴�ֻ�����˼������õ�����
  ShellLink.SetPath(PChar(ProgramPath)); // ��ݷ�ʽ��Ŀ���ļ���һ��Ϊ��ִ���ļ�
  ShellLink.SetArguments(PChar(ProgramArg));// Ŀ���ļ�����
  ShellLink.SetWorkingDirectory(PChar(ExtractFilePath(ProgramPath)));//Ŀ���ļ��Ĺ���Ŀ¼
  ShellLink.SetDescription(PChar(Descr));// ��Ŀ���ļ�������
  FileName := LinkPath;//���ļ���ת��ΪWideString����
  AFile.Save(PWChar(FileName), False);//�����ݷ�ʽ
finally
��OleUninitialize;//�ر�OLE�⣬�˺���������OleInitialize�ɶԵ���
end;

end;

end.
