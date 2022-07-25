//
//  GameSprite.swift
//  penguin
//
//  Created by Gp on 7/1/22.
//

import SpriteKit

protocol GameSprite {
    var textureAtlas: SKTextureAtlas { get set }
    var initialSize: CGSize { get set }
    func onTap()
}
