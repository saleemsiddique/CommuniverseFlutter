import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class HexagonButton extends StatefulWidget {
  final bool showMenu;
  final VoidCallback toggleMenu;

  const HexagonButton({
    Key? key,
    required this.showMenu,
    required this.toggleMenu,
  }) : super(key: key);

  @override
  _HexagonButtonState createState() => _HexagonButtonState();
}

class _HexagonButtonState extends State<HexagonButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    _animation = Tween<double>(begin: 0.5, end: 0.0).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 50,
      child: GestureDetector(
        onTap: () {
          if (widget.showMenu) {
            widget.toggleMenu();
            _controller.reverse(); // Iniciar animación para revertir a rombo
          } else {
            _controller.forward(); // Iniciar animación para girar a cuadrado
            widget.toggleMenu();
          }
        },
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001) // Perspectiva cero para evitar distorsiones visuales
                ..rotateZ(_animation.value * 0.5 * 3.14), // Reducir escala a la mitad
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: widget.showMenu ? Colors.white : Color.fromRGBO(79, 40, 87, 1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Icon(Icons.close_rounded),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}



class MenuWidget extends StatefulWidget {
  final bool showMenu;

  const MenuWidget({Key? key, required this.showMenu}) : super(key: key);

  @override
  _MenuWidgetState createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 1.0, end: 0.7).animate(_controller);
    if (widget.showMenu) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant MenuWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showMenu) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          bottom: 90 + (100 * (1 - _animation.value)), // Adjusts the position of the popup menu
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              createOption("Community"),
              SizedBox(height: 10),
              createOption("Post"),
              SizedBox(height: 10),
              createOption("Quiz")
            ],
          ),
        );
      },
    );
  }

  ElevatedButton createOption(String option) {
    return ElevatedButton(
              onPressed: () {},
              child: SizedBox(
                height: 35,
                width: 120,
                child: Center(child: Text(option, style: TextStyle(color: Colors.black,))),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
            );
  }
}