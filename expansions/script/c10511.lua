--魔光与星尘的连结✿雾雨魔理沙
function c10511.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x208),2)
	c:EnableReviveLimit()
	--equip
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_CHAINING)
	e0:SetRange(LOCATION_MZONE)
	e0:SetOperation(aux.chainreg)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c10511.discon)
	e1:SetOperation(c10511.disop)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c10511.val)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10511,0))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c10511.destg)
	e3:SetOperation(c10511.desop)
	c:RegisterEffect(e3)
end
function c10511.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and re:GetHandler():IsType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and e:GetHandler():GetFlagEffect(1)>0
end
function c10511.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local spr=re:GetHandler()
		spr:CancelToGrave()
		if not Duel.Equip(tp,spr,c,false) then return end
		--Add Equip limit
		e:SetLabelObject(spr)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(c10511.eqlimit)
		spr:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		spr:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		spr:RegisterEffect(e3)
end
function c10511.eqlimit(e,c)
	return e:GetOwner()==c
end
function c10511.val(e,c)
	return c:GetEquipCount()*400
end
function c10511.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetLinkedGroupCount()>0 end
	local g=e:GetHandler():GetLinkedGroup()
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,1-tp,1000)
end
function c10511.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetLinkedGroup()
	if Duel.Destroy(g,REASON_EFFECT)>0 then
		Duel.Damage(1-tp,1000,REASON_EFFECT)
	end
end
