import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../core/network/app_config.dart';

class ServerSettingsPage extends StatefulWidget {
  const ServerSettingsPage({super.key});

  @override
  State<ServerSettingsPage> createState() =>
      _ServerSettingsPageState();
}

class _ServerSettingsPageState extends State<ServerSettingsPage> {
  final TextEditingController _serverController =
      TextEditingController();

  bool _isLoading = true;
  bool _isTesting = false;
  bool _isSaving = false;

  bool? _connectionSuccess;
  String _connectionMessage = '';

  @override
  void initState() {
    super.initState();
    _loadServerUrl();
  }

  Future<void> _loadServerUrl() async {
    try {
      final url = await AppConfig.getServerUrl();

      if (!mounted) return;

      setState(() {
        _serverController.text = url;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _serverController.text = AppConfig.defaultServerUrl;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _serverController.dispose();
    super.dispose();
  }

  String _getApiUrl() {
    final serverUrl = AppConfig.normalizeUrl(
      _serverController.text,
    );

    return '$serverUrl/api/products';
  }

  Future<void> _testConnection() async {
    FocusScope.of(context).unfocus();

    final url = _serverController.text.trim();

    if (url.isEmpty) {
      _showMessage(
        'URL server tidak boleh kosong.',
        isError: true,
      );
      return;
    }

    setState(() {
      _isTesting = true;
      _connectionSuccess = null;
      _connectionMessage = 'Sedang menghubungkan ke server...';
    });

    try {
      final dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 8),
          receiveTimeout: const Duration(seconds: 8),
          sendTimeout: const Duration(seconds: 8),
        ),
      );

      final response = await dio.get(
        _getApiUrl(),
      );

      final success =
          response.data is Map &&
          response.data['success'] == true;

      if (!mounted) return;

      setState(() {
        _connectionSuccess = success;
        _connectionMessage = success
            ? 'Server berhasil terhubung.'
            : 'Server merespons, tetapi format API tidak sesuai.';
      });
    } on DioException catch (error) {
      if (!mounted) return;

      setState(() {
        _connectionSuccess = false;
        _connectionMessage = _dioErrorMessage(error);
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _connectionSuccess = false;
        _connectionMessage = 'Gagal terhubung ke server.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isTesting = false;
        });
      }
    }
  }

  String _dioErrorMessage(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Koneksi timeout. Periksa IP dan jaringan.';

      case DioExceptionType.connectionError:
        return 'Server tidak dapat dijangkau. '
            'Periksa IP, Wi-Fi, dan port 8000.';

      case DioExceptionType.badResponse:
        return 'Server merespons dengan HTTP '
            '${error.response?.statusCode}.';

      default:
        return 'Tidak dapat terhubung ke server.';
    }
  }

  Future<void> _saveServer() async {
    FocusScope.of(context).unfocus();

    final url = _serverController.text.trim();

    if (url.isEmpty) {
      _showMessage(
        'URL server tidak boleh kosong.',
        isError: true,
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final normalizedUrl = AppConfig.normalizeUrl(url);

      await AppConfig.saveServerUrl(normalizedUrl);

      if (!mounted) return;

      setState(() {
        _serverController.text = normalizedUrl;
        _connectionSuccess = null;
        _connectionMessage = '';
      });

      _showMessage(
        'Pengaturan server berhasil disimpan.',
      );
    } catch (_) {
      if (!mounted) return;

      _showMessage(
        'Gagal menyimpan pengaturan server.',
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _resetServer() async {
    FocusScope.of(context).unfocus();

    final shouldReset = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Reset Server'),
          content: const Text(
            'Kembalikan alamat server ke pengaturan default?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );

    if (shouldReset != true) return;

    try {
      await AppConfig.resetServerUrl();

      if (!mounted) return;

      setState(() {
        _serverController.text =
            AppConfig.defaultServerUrl;
        _connectionSuccess = null;
        _connectionMessage = '';
      });

      _showMessage(
        'Server dikembalikan ke pengaturan default.',
      );
    } catch (_) {
      if (!mounted) return;

      _showMessage(
        'Gagal mereset pengaturan server.',
        isError: true,
      );
    }
  }

  void _showMessage(
    String message, {
    bool isError = false,
  }) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor:
              isError ? Colors.red : null,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan Server'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const Icon(
                    Icons.dns_rounded,
                    size: 64,
                  ),

                  const SizedBox(height: 16),

                  Text(
                    'Server API',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Atur alamat server yang digunakan '
                    'oleh aplikasi DuloyShop.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium,
                  ),

                  const SizedBox(height: 32),

                  TextField(
                    controller: _serverController,
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      labelText: 'URL Server',
                      hintText:
                          'http://192.168.1.10:8000',
                      prefixIcon: Icon(Icons.link),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Contoh: http://192.168.1.20:8000',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall,
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: _isTesting
                          ? null
                          : _testConnection,
                      icon: _isTesting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(
                              Icons.wifi_find,
                            ),
                      label: Text(
                        _isTesting
                            ? 'Menguji Koneksi...'
                            : 'Test Koneksi',
                      ),
                    ),
                  ),

                  if (_connectionMessage.isNotEmpty) ...[
                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(12),
                        color: _connectionSuccess == true
                            ? Colors.green.withValues(
                                alpha: 0.12,
                              )
                            : Colors.red.withValues(
                                alpha: 0.12,
                              ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _connectionSuccess == true
                                ? Icons.check_circle
                                : Icons.error,
                            color:
                                _connectionSuccess == true
                                    ? Colors.green
                                    : Colors.red,
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Text(
                              _connectionMessage,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),

                  SizedBox(
                    height: 50,
                    child: FilledButton.icon(
                      onPressed: _isSaving
                          ? null
                          : _saveServer,
                      icon: _isSaving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.save),
                      label: Text(
                        _isSaving
                            ? 'Menyimpan...'
                            : 'Simpan Server',
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  TextButton.icon(
                    onPressed: _resetServer,
                    icon: const Icon(Icons.restore),
                    label: const Text(
                      'Kembalikan ke Default',
                    ),
                  ),

                  const SizedBox(height: 24),

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Informasi',
                                style: TextStyle(
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          Text(
                            'Pastikan HP dan komputer/server '
                            'berada pada jaringan yang sama. '
                            'Jika IP server berubah, cukup ubah '
                            'URL di halaman ini tanpa build '
                            'ulang APK.',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
