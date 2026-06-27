import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile/presentation/widgets/animated_background.dart';
import 'package:mobile/services/api_service.dart';

// ---------------------------------------------------------------------------
// Data models
// ---------------------------------------------------------------------------

class TrendingCoin {
  final String name;
  final String symbol;
  final String rank;
  final String imageUrl; // placeholder – swap for real asset/network image later

  const TrendingCoin({
    required this.name,
    required this.symbol,
    required this.rank,
    required this.imageUrl,
  });
}

class NewsArticle {
  String title;
  String subtitle;
  String date;
  String url;

  NewsArticle({
    required this.title,
    required this.subtitle,
    required this.date,
    required this.url,
  });
}

// ---------------------------------------------------------------------------
// Mock data – replace with real API calls later
// ---------------------------------------------------------------------------

final List<TrendingCoin> _mockTrendingCoins = [
  const TrendingCoin(name: 'Pequeno Pepe', symbol: 'LILPEPE', rank: '#11',  imageUrl: ''),
  const TrendingCoin(name: 'Bitcoin',      symbol: 'BTC',     rank: '#1',   imageUrl: ''),
  const TrendingCoin(name: 'Plasma',       symbol: 'XPL',     rank: '#129', imageUrl: ''),
  const TrendingCoin(name: 'Estaca de Pedra', symbol: 'STO',  rank: '#416', imageUrl: ''),
  const TrendingCoin(name: 'Isqueiro',     symbol: 'LIT',     rank: '#149', imageUrl: ''),
  const TrendingCoin(name: 'Protocolo de Deriva', symbol: 'DERIVA', rank: '#624', imageUrl: ''),
];

final List<NewsArticle> _mockArticles = [
  NewsArticle(
    title: 'Pequeno Pepe (LILPEPE)',
    subtitle: 'Classificação por capitalização de mercado: #11',
    date: '02 de abril de 2026',
    url: '',
  ),
  NewsArticle(
    title: 'Bitcoin (BTC)',
    subtitle: 'Classificação por capitalização de mercado: #1',
    date: '02 de abril de 2026',
    url: '',
  ),
  NewsArticle(
    title: 'Plasma (XPL)',
    subtitle: 'Classificação por capitalização de mercado: #129',
    date: '02 de abril de 2026',
    url: '',
  ),
  NewsArticle(
    title: 'StakeStone (STO)',
    subtitle: 'Classificação por capitalização de mercado: #416',
    date: '02 de abril de 2026',
    url: '',
  ),
  NewsArticle(
    title: 'Cartesi (CTSI)',
    subtitle: 'Classificação por capitalização de mercado: #579',
    date: '02 de abril de 2026',
    url: '',
  ),
  NewsArticle(
    title: 'Isqueiro (aceso)',
    subtitle: 'Classificação por capitalização de mercado: #149',
    date: '02 de abril de 2026',
    url: '',
  ),
  NewsArticle(
    title: 'Protocolo de Deriva (DRIFT)',
    subtitle: 'Classificação por capitalização de mercado: #624',
    date: '02 de abril de 2026',
    url: '',
  ),
  NewsArticle(
    title: 'Pinguins Gordinhos (PENGU)',
    subtitle: 'Classificação por capitalização de mercado: #107',
    date: '02 de abril de 2026',
    url: '',
  ),
  NewsArticle(
    title: 'Ethereum (ETH)',
    subtitle: 'Classificação por capitalização de mercado: #2',
    date: '02 de abril de 2026',
    url: '',
  ),
  NewsArticle(
    title: 'XRP (XRP)',
    subtitle: 'Classificação por capitalização de mercado: #4',
    date: '02 de abril de 2026',
    url: '',
  ),
];

// ---------------------------------------------------------------------------
// Color tokens
// ---------------------------------------------------------------------------

const _bgDeep    = Color(0xFF0B0F1A);
const _bgCard    = Color(0xFF131929);
const _bgPanel   = Color(0xFF0F1623);
const _accent    = Color(0xFF00E5FF);
const _textPri   = Color(0xFFFFFFFF);
const _textSec   = Color(0xFF8A9BBE);
const _borderCol = Color(0xFF1E2D4A);

// ---------------------------------------------------------------------------
// Main page widget (used as the "Aba 2" content inside MainShell)
// ---------------------------------------------------------------------------

class NewsPageContent extends StatefulWidget {
  const NewsPageContent({super.key});

  @override
  State<NewsPageContent> createState() => _NewsPageContentState();
}

class _NewsPageContentState extends State<NewsPageContent> {
  final TextEditingController _searchController = TextEditingController();
  late Timer _refreshTimer;
  bool _isRefreshing = false;
  String _filterText = '';
  List<NewsArticle> _articles = List.from(_mockArticles);

  @override
  void initState() {
    super.initState();
    // Auto-refresh every 30 seconds
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) => _refresh());
    // Load notifications on startup
    _refresh();
  }

  @override
  void dispose() {
    _refreshTimer.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    if (_isRefreshing) return;
    setState(() => _isRefreshing = true);
    
    try {
      final notifications = await ApiService.getNotifications();
      
      if (notifications != null && mounted) {
        setState(() {
          _articles = notifications.map((notif) {
            return NewsArticle(
              title: notif['title'] ?? 'Sem título',
              subtitle: notif['message'] ?? '',
              date: notif['createdAt'] ?? DateTime.now().toString(),
              url: '',
            );
          }).toList();
        });
      }
    } catch (e) {
      print('Erro ao carregar notificações: $e');
    }
    
    if (mounted) setState(() => _isRefreshing = false);
  }

  List<NewsArticle> get _filteredArticles {
    if (_filterText.isEmpty) return _articles;
    final q = _filterText.toLowerCase();
    return _articles
        .where((a) =>
            a.title.toLowerCase().contains(q) ||
            a.subtitle.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _bgDeep,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPageHeader(),
            _buildTrendingCarousel(),
            _buildSearchBar(),
            const SizedBox(height: 8),
            _buildArticleGrid(),
            _buildFooterNote(),
          ],
        ),
      ),
    );
  }

  // ── Page title + refresh button ─────────────────────────────────────────

  Widget _buildPageHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Portal de Notícias',
                style: const TextStyle(
                  color: _textPri,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Últimas notícias e tendências do mundo criptológico',
                style: TextStyle(color: _textSec, fontSize: 11.5),
              ),
            ],
          ),
          _RefreshButton(isLoading: _isRefreshing, onTap: _refresh),
        ],
      ),
    );
  }

  // ── Horizontal trending carousel ────────────────────────────────────────

  Widget _buildTrendingCarousel() {
    return Container(
      margin: const EdgeInsets.only(top: 14),
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: _bgPanel,
        border: Border(
          top:    BorderSide(color: _borderCol, width: 1),
          bottom: BorderSide(color: _borderCol, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: const [
                Icon(Icons.trending_up_rounded, color: _accent, size: 16),
                SizedBox(width: 6),
                Text(
                  'Moedas em Alta',
                  style: TextStyle(
                    color: _textPri,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 110,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _mockTrendingCoins.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, i) => _TrendingCard(coin: _mockTrendingCoins[i]),
            ),
          ),
        ],
      ),
    );
  }

  // ── Keyword filter ───────────────────────────────────────────────────────

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: _bgCard,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _borderCol),
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            const Icon(Icons.filter_list_rounded, color: _textSec, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: _textPri, fontSize: 13.5),
                cursorColor: _accent,
                decoration: const InputDecoration(
                  hintText: 'Filtrar por palavra chave...',
                  hintStyle: TextStyle(color: _textSec, fontSize: 13.5),
                  border: InputBorder.none,
                  isDense: true,
                ),
                onChanged: (v) => setState(() => _filterText = v),
              ),
            ),
            if (_filterText.isNotEmpty)
              GestureDetector(
                onTap: () {
                  _searchController.clear();
                  setState(() => _filterText = '');
                },
                child: const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(Icons.close_rounded, color: _textSec, size: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ── Article grid ─────────────────────────────────────────────────────────

  Widget _buildArticleGrid() {
    final items = _filteredArticles;
    if (items.isEmpty) {
      return const Center(
        child: Text(
          'Nenhuma notícia encontrada.',
          style: TextStyle(color: _textSec, fontSize: 14),
        ),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),

      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),

      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.35,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) => _ArticleCard(article: items[i]),
    );
  }

  // ── Bottom attribution note ───────────────────────────────────────────────

  Widget _buildFooterNote() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: const [
          Text(
            'Notícias fornecidas por coindesk RSS Feed',
            style: TextStyle(color: _textSec, fontSize: 10.5),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2),
          Text(
            'Atualização automática a cada 30 segundos',
            style: TextStyle(color: _textSec, fontSize: 10.5),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sub-widgets
// ---------------------------------------------------------------------------

class _RefreshButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;
  const _RefreshButton({required this.isLoading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: _accent.withOpacity(0.12),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: _accent.withOpacity(0.35)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            isLoading
                ? SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: _accent,
                    ),
                  )
                : const Icon(Icons.refresh_rounded, color: _accent, size: 14),
            const SizedBox(width: 6),
            const Text(
              'Atualizar',
              style: TextStyle(
                color: _accent,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Trending coin card ──────────────────────────────────────────────────────

class _TrendingCard extends StatelessWidget {
  final TrendingCoin coin;
  const _TrendingCard({required this.coin});

  // Returns a deterministic placeholder color based on symbol
  Color _placeholderColor() {
    const colors = [
      Color(0xFF1E3A5F),
      Color(0xFF1A3D2E),
      Color(0xFF3D1A1A),
      Color(0xFF2D1A3D),
      Color(0xFF3D2D1A),
      Color(0xFF1A3D3D),
    ];
    return colors[coin.symbol.length % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      decoration: BoxDecoration(
        color: _bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderCol),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Coin logo placeholder – swap imageUrl for real asset later
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _placeholderColor(),
              shape: BoxShape.circle,
              border: Border.all(color: _borderCol, width: 1.5),
            ),
            child: Center(
              child: Text(
                coin.symbol.length > 3
                    ? coin.symbol.substring(0, 2)
                    : coin.symbol.substring(0, 1),
                style: const TextStyle(
                  color: _textPri,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            coin.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _textPri,
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            coin.symbol,
            style: const TextStyle(color: _textSec, fontSize: 9.5),
          ),
          const SizedBox(height: 2),
          Text(
            coin.rank,
            style: const TextStyle(color: _accent, fontSize: 9.5),
          ),
        ],
      ),
    );
  }
}

// ── News article card ───────────────────────────────────────────────────────

class _ArticleCard extends StatelessWidget {
  final NewsArticle article;
  const _ArticleCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _bgCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _borderCol),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.article_outlined, color: _textSec, size: 16),
              Icon(Icons.open_in_new_rounded, color: _textSec, size: 14),
            ],
          ),
          const Spacer(),
          // Title
          Text(
            article.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _textPri,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 3),
          // Subtitle (rank)
          Text(
            article.subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: _textSec, fontSize: 9.5, height: 1.3),
          ),
          const Spacer(),
          // Date + read more
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                article.date,
                style: const TextStyle(color: _textSec, fontSize: 8.5),
              ),
              GestureDetector(
                onTap: () {
                  // TODO: launch article.url
                },
                child: const Text(
                  'Ler mais',
                  style: TextStyle(
                    color: _accent,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}