/*
 * 由SharpDevelop创建。
 * 用户： Acer
 * 日期: 5月12 星期一
 * 时间: 12:00
 * 
 */
using DataEditorX.Config;
using DataEditorX.Language;
using System.Text;
using Serilog;

namespace DataEditorX
{
    internal sealed class Program
    {
        [STAThread]
        private static void Main(string[] args)
        {
            try
            {
                LoggingConfig.ConfigureLogging();
                AppDomain.CurrentDomain.UnhandledException += (sender, e) =>
                {
                    Log.Error((Exception)e.ExceptionObject, "Unhandled exception occurred");
                };

                string arg = (args.Length > 0) ? args[0] : "";
                if (arg == DEXConfig.TAG_SAVE_LAGN || arg == DEXConfig.TAG_SAVE_LAGN2)
                {
                    //保存语言
                    SaveLanguage();
                    _ = MessageBox.Show("Save Language OK.");
                    Environment.Exit(1);
                }
                if (DEXConfig.OpenOnExistForm(arg))//在已经存在的窗口打开文件
                {
                    Environment.Exit(1);
                }
                else//新建窗口
                {
                    Application.EnableVisualStyles();
                    Application.SetCompatibleTextRenderingDefault(false);
                    MainForm mainForm = new();
                    //设置将要打开的文件
                    mainForm.SetOpenFile(arg);
                    //数据目录
                    mainForm.SetDataPath(MyPath.Combine(Application.StartupPath, DEXConfig.TAG_DATA));

                    Application.Run(mainForm);

                    Dictionary<long, string> dic = mainForm.GetDataConfig().dicSetnames;
                    Dictionary<long, string> old = mainForm.GetDataConfig(true).dicSetnames;
                    foreach (long setcode in dic.Keys)
                    {
                        if (old.ContainsKey(setcode))
                            continue;
                        string cardinfo = DEXConfig.GetCardInfoFile(MyPath.Combine(Application.StartupPath,
                            DEXConfig.TAG_DATA));
                        if (File.Exists(cardinfo))
                        {
                            try
                            {
                                using (FileStream cStream = new(cardinfo, FileMode.Open, FileAccess.ReadWrite))
                                {
                                    byte[] content = Encoding.UTF8.GetBytes($"\n0x{setcode:x}\t{dic[setcode]}\n#end");
                                    cStream.Seek(-5, SeekOrigin.End);
                                    cStream.Write(content, 0, content.Length);
                                }
                            }
                            catch (Exception ex)
                            {
                                MessageBox.Show($"Error updating card info file: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                            }
                        }

                        string file = MyPath.Combine(Application.StartupPath, DEXConfig.TAG_DATA, DEXConfig.FILE_STRINGS);
                        if (!string.IsNullOrEmpty(file) && File.Exists(file))
                        {
                            try
                            {
                                using (FileStream sStream = new(file, FileMode.Open, FileAccess.Write))
                                {
                                    byte[] content = Encoding.UTF8.GetBytes($"!setname 0x{setcode:x} {dic[setcode]}\n");
                                    sStream.Seek(0, SeekOrigin.End);
                                    sStream.Write(content, 0, content.Length);
                                }
                            }
                            catch (Exception ex)
                            {
                                MessageBox.Show($"Error updating strings file: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Log.Fatal(ex, "Application terminated unexpectedly");
                MessageBox.Show($"Application error: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            finally
            {
                Log.CloseAndFlush();
            }
        }
        static void SaveLanguage()
        {
            string datapath = MyPath.Combine(Application.StartupPath, DEXConfig.TAG_DATA);
            string conflang = DEXConfig.GetLanguageFile(datapath);
            LanguageHelper.LoadFormLabels(conflang);
            LanguageHelper langhelper = new();
            MainForm form1 = new();
            LanguageHelper.SetFormLabel(form1);
            langhelper.GetFormLabel(form1);
            DataEditForm form2 = new();
            LanguageHelper.SetFormLabel(form2);
            langhelper.GetFormLabel(form2);
            CodeEditForm form3 = new();
            LanguageHelper.SetFormLabel(form3);
            langhelper.GetFormLabel(form3);
            // LANG.GetFormLabel(this);
            //获取窗体文字
            _ = langhelper.SaveLanguage(conflang + ".bak");
        }

    }
}
