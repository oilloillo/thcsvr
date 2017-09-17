--郁冥与幻想的连结✿博丽灵梦
function c10501.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x208),2)
	c:EnableReviveLimit()
	--atkdown
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetValue(c10501.atkval)
	c:RegisterEffect(e1)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	--msfy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10501,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_F)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c10501.poscon)
	e2:SetTarget(c10501.postg)
	e2:SetOperation(c10501.posop)
	c:RegisterEffect(e2)
	--jianbolan
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10501,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(c10501.drcon)
	e3:SetTarget(c10501.drtg)
	e3:SetOperation(c10501.drop)
	c:RegisterEffect(e3)
end
function c10501.atkval(e,c)
	local val=math.max(c:GetLevel(),c:GetRank())
	return val*-100
end
function c10501.cfilter(c,ec,tp)
	return c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 and c:IsControler(1-tp) and not ec:GetLinkedGroup():IsContains(c)
end
function c10501.poscon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10501.cfilter,1,nil,e:GetHandler(),tp)
end
function c10501.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(eg:GetFirst())
end
function c10501.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_ATTACK)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_EFFECT)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e3)
	end
end
function c10501.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
function c10501.filter(c,tp)
	return c:IsLocation(LOCATION_GRAVE) and c:IsControler(tp) and c:IsAbleToHand()
end
function c10501.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mg=e:GetHandler():GetMaterial()
	if chk==0 then return mg:IsExists(c10501.filter,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c10501.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=e:GetHandler():GetMaterial()
	local sg=mg:FilterSelect(c10501.filter,1,1,nil,tp)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(sg,1-tp)
	end
end
