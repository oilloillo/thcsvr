--宵暗的妖怪✿芙兰朵露
--require "expansions/nef/nef"
function c19025.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_SPSUMMON_COUNT)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsSetCard,0x815),aux.FilterBoolFunction(Card.IsSetCard,0x110),true)

		--destroy
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(19025,0))
		e1:SetCategory(CATEGORY_DESTROY)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetTarget(c19025.target)
		e1:SetOperation(c19025.operation)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EVENT_ATTACK_ANNOUNCE)
		c:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EVENT_TO_GRAVE)
		c:RegisterEffect(e3)

		--spsummon count limit
		-- not local!!
		c19025.esplimit = Effect.CreateEffect(c)
		c19025.esplimit:SetType(EFFECT_TYPE_FIELD)
		c19025.esplimit:SetCode(EFFECT_SPSUMMON_COUNT_LIMIT)
		c19025.esplimit:SetRange(LOCATION_MZONE)
		c19025.esplimit:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		c19025.esplimit:SetTargetRange(0,1)
		c19025.esplimit:SetValue(1)
		-- e4:SetCondition(c19025.slcon)
		-- c:RegisterEffect(e4)

		-- start effect
		local e4 = Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_ADJUST)
		e4:SetRange(LOCATION_MZONE)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
		e4:SetCondition(c19025.startcon)
		e4:SetOperation(c19025.startop)
		e4:SetLabelObject(nil)
		c:RegisterEffect(e4)

		-- reset effect
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e5:SetCode(EVENT_MSET)
		e5:SetRange(LOCATION_MZONE)
		e5:SetOperation(c19025.sop)
		e5:SetLabelObject(e4)
		c:RegisterEffect(e5)
		local e6=e5:Clone()
		e6:SetCode(EVENT_SSET)
		c:RegisterEffect(e6)

end


function c19025.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsFacedown() end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsFacedown,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end


function c19025.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFacedown() then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

function c19025.startcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetLabelObject() and not e:GetHandler():IsDisabled() and
		not c19025.slcon(e:GetHandler())
end

function c19025.startop(e,tp,eg,ep,ev,re,r,rp)
	local e1 = c19025.esplimit:Clone()
	e:GetHandler():RegisterEffect(e1)
	e:SetLabelObject(e1)
end

function c19025.slcon(tc)
	return tc:GetFlagEffect(19025)>=2
end


function c19025.sop(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp then return end
	local te = e:GetLabelObject():GetLabelObject()
	if not te then return end
	e:GetHandler():RegisterFlagEffect(19025,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	if c19025.slcon(e:GetHandler()) then
		te:Reset()
		e:GetLabelObject():SetLabelObject(nil)
	end 
end

